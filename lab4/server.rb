require 'socket'
require_relative "config.rb"
include Socket::Constants

server  = Socket.new(AF_INET,SOCK_STREAM,0)
server.setsockopt(Socket::SOL_SOCKET,Socket::SO_REUSEADDR,true)

file = File.open(OUTPUT_FILE_NAME, OVERWRITE)

sockaddr = Socket.sockaddr_in(PORT,HOST)
server.bind(sockaddr)
server.listen(1)
trap('INT') do
puts
puts AT_EXIT
exit
end
client, client_addrinfo = server.accept


recieve_len = 0;
recieve_count = 0;

begin
	loop do
 		r,_,e = IO.select([client],nil,[client],1)
        if (!r ) 
			break
		end  
        
        if recv_from = r.shift 
            data = recv_from.recv(BUFFER_SIZE)
            if data.empty?
				break
			end
            file.write(data);
            recieve_len+=data.length
            recieve_count+=1
		end
        if recv_from =e.shift 
            data = recv_from.recv(BUFFER_SIZE,Socket::MSG_OOB) 
  			puts data
		end 
    end


rescue
	puts
    raise

ensure
    file.close  
    server.close
    client.close
    puts "recieve length = #{recieve_len}"
    puts "recieve count = #{recieve_count}"
end

