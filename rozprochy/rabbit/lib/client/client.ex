defmodule Client do
  use GenServer

  def start_link(name) do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)

    AMQP.Exchange.declare(channel, "orders", :direct)
    AMQP.Exchange.declare(channel, "processed", :direct)

    {:ok, %{queue: queue}} = AMQP.Queue.declare(channel, "")
    AMQP.Queue.bind(channel, queue, "processed", routing_key: name)
    AMQP.Basic.consume(channel, queue, nil, no_ack: false)
    IO.puts("#{name} zaczyna")

    GenServer.start_link(
      __MODULE__,
      {name, connection, channel, queue, []},
      name: __MODULE__
    )
  end

  @impl true
  def init(state) do
    Process.flag(:trap_exit, true)
    {:ok, state}
  end

  def order(item) do
    GenServer.cast(__MODULE__, {:order, item})
  end

  def confirm() do
    receive do
      {:basic_deliver, payload, meta} ->
        GenServer.call(__MODULE__, {:confirm, payload, meta}, :infinity)
    end
  end

  def confirm_all() do
    items = elem(:sys.get_state(__MODULE__), 4)

    if length(items) > 0 do
      confirm()
      confirm_all()
    end
  end

  @impl true
  def handle_cast(
        {:order, item},
        {name, _, channel, _, items} = state
      ) do
    :ok =
      AMQP.Basic.publish(
        channel,
        "orders",
        item,
        name
      )

    new_state = put_elem(state, 4, [item | items])
    {:noreply, new_state}
  end

  @impl true
  def handle_call(
        {:confirm, payload, meta},
        _,
        {_, _, channel, _, items} = state
      ) do
    {:ok, decoded} = payload |> Base.decode64()
    {item, supplier, id} = decoded |> :erlang.binary_to_term()
    AMQP.Basic.ack(channel, meta.delivery_tag)
    IO.puts("Zamówiono #{item} (numer zamówienia #{id}) u #{supplier}")
    new_state = put_elem(state, 4, tl(items))
    {:reply, payload, new_state}
  end

  @impl true
  def terminate(_, {_, connection, _, _, _}) do
    AMQP.Connection.close(connection)
  end
end
