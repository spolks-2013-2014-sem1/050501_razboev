require 'socket'
require 'slop'
require_relative "config.rb"
include Socket::Constants

opts = Slop.parse(help: false) do
  on :h, :host=, 'Host'
  on :f, :file=, 'Filename'
  on :p, :port=, 'Port'
end

trap('INT') do
puts AT_EXIT
exit
end

client  = Socket.new(AF_INET,SOCK_STREAM,0)
client.setsockopt(Socket::SOL_SOCKET,Socket::SO_REUSEADDR,true)
file = File.open(opts[:f], READONLY)

port = opts[:p] || PORT
host = opts[:h] || HOST
 
client.connect(Socket.sockaddr_in(port,host ))



begin
while data = file.read(BUFFER_SIZE)
    client.write(data)
   # puts data
    end


rescue 
   puts ERROR
   raise


ensure 
   client.close
   file.close
end
