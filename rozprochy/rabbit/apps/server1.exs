# Server.start_link({"Dostawca 1", ["tlen", "buty"]})
# Server.serve()
name = "Dostawca 1"
items = ["tlen", "buty"]

{:ok, connection} = AMQP.Connection.open()
{:ok, channel} = AMQP.Channel.open(connection)

AMQP.Exchange.declare(channel, "orders", :direct)
# AMQP.Exchange.declare(channel, "processed", :direct)

{:ok, %{queue: queue}} = AMQP.Queue.declare(channel, "", exclusive: true)

items
|> Enum.map(fn item ->
  AMQP.Queue.bind(channel, queue, "orders", routing_key: item)
end)

AMQP.Basic.consume(channel, queue, nil, no_ack: true)

defmodule Server do
  def serve() do
    receive do
      {:basic_deliver, payload, meta} ->
        IO.inspect("#{payload} - #{meta}", label: "SERVER")
        serve()
    end

    # IO.puts("#{crew}: #{item}")
    # serve()
  end
end

Server.serve()

AMQP.Connection.close(connection)
