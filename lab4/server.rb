require 'socket'
require 'slop'
require_relative "config.rb"
include Socket::Constants

opts = Slop.parse(help: false) do
  on :h, :host=, 'Host'
  on :p, :port=, 'Port'
  on :e, :ext=,  'Extension'	
end


server  = Socket.new(AF_INET,SOCK_STREAM,0)
server.setsockopt(Socket::SOL_SOCKET,Socket::SO_REUSEADDR,true)
output = OUTPUT_FILE_NAME + "." +opts[:e]
file = File.open(output, OVERWRITE)
port = opts[:p] || PORT
host = opts[:h] || HOST
sockaddr = Socket.sockaddr_in(port,host)
server.bind(sockaddr)
server.listen(1)
trap('INT') do
puts
puts AT_EXIT
exit
end
client, client_addrinfo = server.accept

oob_data = 0;
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
			oob_data+=1 
  			puts recieve_len
		end 
    end


rescue
	puts
    raise

ensure
    file.close  
    server.close
    client.close
	puts "oob data = #{oob_data}"
    puts "recieve length = #{recieve_len}"
    puts "recieve count = #{recieve_count}"
end

