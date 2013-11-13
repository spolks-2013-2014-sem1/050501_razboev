require 'socket'
include Socket::Constants






client  = Socket.new(AF_INET,SOCK_STREAM,0)
client.setsockopt(Socket::SOL_SOCKET,Socket::SO_REUSEADDR,true)
file = File.open("input", 'r')


client.connect(Socket.sockaddr_in(3005,'localhost'))

begin
while data = file.read(1)
    client.write(data)
   # puts data
    end


rescue 
   puts "fail"
   raise


ensure 
   client.close

end
