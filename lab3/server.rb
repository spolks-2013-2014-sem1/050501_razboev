require 'socket'
require_relative "config.rb"
include Socket::Constants

server  = Socket.new(AF_INET,SOCK_STREAM,0)
server.setsockopt(Socket::SOL_SOCKET,Socket::SO_REUSEADDR,true)
file = File.open(OUTPUT_FILE_NAME, OVERWRITE)

sockaddr = Socket.sockaddr_in(PORT,HOST)
server.bind(sockaddr)
server.listen(1)


client, client_addrinfo = server.accept

trap('EXIT') do
at_axit {puts AT_EXIT}
exit
end

begin
	while  data = client.read(BUFFER_SIZE)
           file.write(data)
          # puts data
    end

rescue
	puts ERROR
    raise

ensure
  	file.close  
    server.close
    client.close
end

