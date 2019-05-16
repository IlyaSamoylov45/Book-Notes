defmodule PingPong.Runner do
  def loop do
   receive do
     {sender_pid, :ping} ->
       IO.puts "ping";
       send sender_pid, {self(), :pong}
     {sender_pid, :pong} ->
       IO.puts "pong";
       send sender_pid, {self(), :ping}
     _ ->
       IO.puts "don't know how to process this message"
   end
   loop()
  end
end


defmodule Start do
  def start() do
    ping = spawn(PingPong.Runner, :loop, [])
    pong = spawn(PingPong.Runner, :loop, [])
    send ping, {pong, :ping}
  end

end
