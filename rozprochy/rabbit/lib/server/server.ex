defmodule Server do
  use GenServer

  def start_link({name, items}) do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)
    AMQP.Basic.qos(channel, prefetch_count: 1)

    AMQP.Exchange.declare(channel, "orders", :direct)
    AMQP.Exchange.declare(channel, "processed", :direct)

    {:ok, %{queue: queue}} = AMQP.Queue.declare(channel, "", exclusive: true)

    items
    |> Enum.map(fn item ->
      AMQP.Queue.bind(channel, queue, "orders", routing_key: item)
    end)

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

  def order(crew, item, meta) do
    GenServer.call(__MODULE__, {:order, crew, item, meta})
  end

  def handle_call(
        {:order, crew, item, meta},
        _,
        {name, connection, channel, queue} = state
      ) do
    AMQP.Basic.ack(channel, meta.delivery_tag)
    AMQP.Basic.publish(
      channel,
      "processed",
      crew,
      item
    )

    IO.puts("Zamawiający: #{crew}, przedmiot: #{item}")

    {:reply, item, state}
  end

  def serve() do
    receive do
      {:basic_deliver, payload, meta} ->
        order(payload, meta.routing_key, meta)
        serve()
    end
  end

  def terminate(_reason, {_, connection, _}) do
    AMQP.Connection.close(connection)
  end
end
