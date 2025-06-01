# defmodule Client do
#   use GenServer

#   def start_link(name) do
#     {:ok, connection} = AMQP.Connection.open()
#     {:ok, channel} = AMQP.Channel.open(connection)

#     AMQP.Exchange.declare(channel, "orders", :direct)
#     # AMQP.Exchange.declare(channel, "processed", :direct)

#     # {:ok, %{queue: queue}} = AMQP.Queue.declare(channel, "", exclusive: true)
#     # AMQP.Queue.bind(channel, queue, "processed", routing_key: name)
#     queue = nil

#     GenServer.start_link(__MODULE__, {name, connection, channel, queue}, name: __MODULE__)
#   end

#   def init(state) do
#     Process.flag(:trap_exit, true)
#     {:ok, state}
#   end

#   def state() do
#     GenServer.call(__MODULE__, :state, :infinity)
#   end

#   def handle_call(:state, _, state) do
#     {:reply, state, state}
#   end

#   def order(item) do
#     GenServer.call(__MODULE__, {:order, item}, :infinity)
#   end

#   def handle_call({:order, item}, _, {name, connection, channel, queue} = state) do
#     AMQP.Basic.publish(
#       channel,
#       "orders",
#       item,
#       %{
#         crew_name: name,
#         item_name: item
#       }
#     )

#     IO.puts("Zamówiono: #{item}")

#     # receive do
#     #   {:order, item, ^name} -> IO.puts("Otrzymano: #{item}")
#     # end
#     {:reply, item, state}
#   end

#   # def wait_for_messages() do
#   #   receive do
#   #     {:order, item, %{correlation_id: ^correlation_id}} ->
#   #       IO.puts(payload)
#   #   end
#   # end

#   def order2(item) do
#     {name, _, channel, _} = __MODULE__.state()
#     AMQP.Basic.publish(
#       channel,
#       "orders",
#       item,
#       {name, item}
#       # %{
#       #   crew_name: name,
#       #   item_name: item
#       # }
#     )

#     IO.puts("Zamówiono: #{item}")
#   end

#   def terminate(_reason, {_, connection, _, _}) do
#     AMQP.Connection.close(connection)
#   end
# end
