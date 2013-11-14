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

trap('INT') do
at_axit {puts AT_EXIT}
exit
end

recieve_len = 0;
recieve_count = 0;

begin
	while  data = client.read(BUFFER_SIZE)
           file.write(data)
          # puts data
	   recieve_count+=1;
           recieve_len+=data.length;
    end

rescue
	puts ERROR
    raise

ensure
    file.close  
    server.close
    client.close
    puts "recieve length = #{recieve_len}"
    puts "recieve count = #{recieve_count}"
end

