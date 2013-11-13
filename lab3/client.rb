require 'socket'
require_relative "config.rb"
include Socket::Constants






client  = Socket.new(AF_INET,SOCK_STREAM,0)
client.setsockopt(Socket::SOL_SOCKET,Socket::SO_REUSEADDR,true)
file = File.open(INPUT_FILE_NAME, READONLY)


client.connect(Socket.sockaddr_in(PORT,HOST ))

trap('EXIT') do
at_axit {puts AT_EXIT}
exit
end

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
