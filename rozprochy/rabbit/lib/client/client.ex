defmodule Client do
  use GenServer

  def start_link(name) do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)
    AMQP.Basic.qos(channel, prefetch_count: 1)

    AMQP.Exchange.declare(channel, "orders", :direct)
    AMQP.Exchange.declare(channel, "processed", :direct)

    {:ok, %{queue: queue}} = AMQP.Queue.declare(channel, "", exclusive: true)
    AMQP.Queue.bind(channel, queue, "processed", routing_key: name)
    AMQP.Basic.consume(channel, queue, nil, no_ack: false, exclusive: true)
    IO.puts("#{name} zaczyna")

    GenServer.start_link(
      __MODULE__,
      {name, connection, channel, queue},
      name: __MODULE__
    )
  end

  def init(state) do
    Process.flag(:trap_exit, true)
    {:ok, state}
  end

  def state() do
    GenServer.call(__MODULE__, :state, :infinity)
  end

  def handle_call(:state, _, state) do
    {:reply, state, state}
  end

  def order(item) do
    GenServer.call(__MODULE__, {:order, item}, :infinity)

    receive do
      {:basic_deliver, payload, meta} ->
        # IO.puts("Zamówiono #{payload} u #{meta.supplier}")
        {_, _, channel, _} = state()
        AMQP.Basic.ack(channel, meta.delivery_tag)
        IO.puts("Zamówiono #{payload}")
    end
  end

  def handle_call({:order, item}, _, {name, connection, channel, queue} = state) do
    :ok = AMQP.Basic.publish(
      channel,
      "orders",
      item,
      name
    )

    {:reply, item, state}
  end

  def terminate(_reason, {_, connection, _, _}) do
    AMQP.Connection.close(connection)
  end
end
