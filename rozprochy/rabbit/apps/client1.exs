# Client.start_link("Ekipa 1")
# Client.order2("tlen")
# Client.order2("buty")

# ["tlen", "tlen", "buty", "buty", "plecak", "plecak"]
# |> Enum.map(fn item -> Client.order(item) end)

{:ok, connection} = AMQP.Connection.open()

name = "Ekipa 1"

{:ok, channel} = AMQP.Channel.open(connection)

AMQP.Exchange.declare(channel, "orders", :direct)
# AMQP.Exchange.declare(channel, "processed", :direct)

# {:ok, %{queue: queue}} = AMQP.Queue.declare(channel, "", exclusive: true)
# AMQP.Queue.bind(channel, queue, "processed", routing_key: name)
queue = nil


AMQP.Basic.publish(
  channel,
  "orders",
  "buty",
  {name, "buty"}
  # %{
  #   crew_name: name,
  #   item_name: item
  # }
)

IO.puts("Zamówiono: buty")

AMQP.Basic.publish(
  channel,
  "orders",
  "tlen",
  {name, "tlen"}
  # %{
  #   crew_name: name,
  #   item_name: item
  # }
)


IO.puts("Zamówiono: tlen")

AMQP.Connection.close(connection)

