require 'socket'
include Socket::Constants
socket  = Socket.new(AF_INET,SOCK_STREAM,0)
sockaddr = Socket.sockaddr_in(3000,'localhost')
socket.bind(sockaddr)
socket.listen(5)
puts "hello "
client_fd,client_addrinfo = socket.sysaccept
client_socket = Socket.for_fd(client_fd)
loop do
	data = client_socket.readline.chomp
	puts "client say: #{data}"
        client_socket.puts "server say : #{data.reverse}"
	if data == "close"
		break
	end

end
socket.close
puts "end all close" 
