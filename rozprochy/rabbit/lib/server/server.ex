defmodule Server do
  use GenServer

  def create_queue(channel, item) do
    {:ok, %{queue: queue}} = AMQP.Queue.declare(channel, item)
    AMQP.Basic.consume(channel, queue, nil, no_ack: false)
    AMQP.Queue.bind(channel, queue, "orders", routing_key: item)
    queue
  end

  def start_link({name, items}) do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)
    AMQP.Exchange.declare(channel, "orders", :direct)
    AMQP.Exchange.declare(channel, "processed", :direct)
    AMQP.Basic.qos(channel, prefetch_count: 1)
    queues = items |> Enum.map(fn item -> create_queue(channel, item) end)
    IO.puts("#{name} zaczyna")

    GenServer.start_link(
      __MODULE__,
      {name, connection, channel, queues},
      name: __MODULE__
    )
  end

  @impl true
  def init(state) do
    Process.flag(:trap_exit, true)
    {:ok, state}
  end

  def order(crew, item, meta) do
    GenServer.cast(__MODULE__, {:order, crew, item, meta})
  end

  @impl true
  def handle_cast(
        {:order, crew, item, meta},
        {name, _, channel, _} = state
      ) do
    AMQP.Basic.ack(channel, meta.delivery_tag)

    AMQP.Basic.publish(
      channel,
      "processed",
      crew,
      {item, name}
      |> :erlang.term_to_binary()
      |> Base.encode64()
    )

    IO.puts("Zamawiający: #{crew}, przedmiot: #{item}")

    {:noreply, state}
  end

  def serve() do
    receive do
      {:basic_deliver, payload, meta} ->
        order(payload, meta.routing_key, meta)
        serve()
    end
  end

  @impl true
  def terminate(_, {_, connection, _}) do
    AMQP.Connection.close(connection)
  end
end
