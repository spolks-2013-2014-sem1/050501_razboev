require 'socket'
include Socket::Constants

server  = Socket.new(AF_INET,SOCK_STREAM,0)
server.setsockopt(Socket::SOL_SOCKET,Socket::SO_REUSEADDR,true)
file = File.open("output", 'w+')

sockaddr = Socket.sockaddr_in(3005,'localhost')
server.bind(sockaddr)
server.listen(1)


client, client_addrinfo = server.accept

begin
	while  data = client.read(1)
           file.write(data)
          # puts data
    end

rescue
	puts "fail"
    raise

ensure
  	file.close  
    server.close
    client.close
end
