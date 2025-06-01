# defmodule Server do
#   use GenServer

#   def start_link({name, items}) do
#     {:ok, connection} = AMQP.Connection.open()
#     {:ok, channel} = AMQP.Channel.open(connection)

#     AMQP.Exchange.declare(channel, "orders", :direct)
#     # AMQP.Exchange.declare(channel, "processed", :direct)

#     {:ok, %{queue: queue}} = AMQP.Queue.declare(channel, "", exclusive: true)

#     items
#     |> Enum.map(fn item ->
#       AMQP.Queue.bind(channel, queue, "orders", routing_key: item)
#     end)

#     AMQP.Basic.consume(channel, queue, nil, no_ack: true)

#     GenServer.start_link(
#       __MODULE__,
#       {name, connection, channel, queue},
#       name: __MODULE__
#     )
#   end

#   def init(state) do
#     Process.flag(:trap_exit, true)
#     {:ok, state}
#   end

#   def order() do
#     GenServer.call(__MODULE__, {:order})
#   end

#   def handle_call(
#         :order,
#         _,
#         {name, connection, channel, queue} = state
#       ) do
#     # AMQP.Basic.publish(
#     #   channel,
#     #   "",
#     #   item
#     # )
#     # TODO response

#     # AMQP.Basic.ack(channel, meta.delivery_tag)
#     {:reply, "", state}
#   end

#   def serve() do
#     receive do
#       {:basic_deliver, payload, meta} ->
#         IO.inspect("#{payload} - #{meta}", label: "SERVER")
#         serve()
#     end

#     # IO.puts("#{crew}: #{item}")
#     serve()
#   end

#   def terminate(_reason, {_, connection, _}) do
#     AMQP.Connection.close(connection)
#   end
# end
