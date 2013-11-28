require 'socket'
require 'slop'
require_relative "config.rb"
include Socket::Constants

opts = Slop.parse(help: false) do
  on :h, :host=, 'Host'
  on :p, :port=, 'Port'
  on :e, :ext=,  'Extension'	
  on :u, :udp , "Udp"
end


trap('INT') do
puts AT_EXIT
exit
end

output = OUTPUT_FILE_NAME + "." +opts[:e] 
file = File.open(output, OVERWRITE)
port = opts[:p] || PORT
host = opts[:h] || HOST

if (opts[:u])
	puts "udp Proto"
	client  = Socket.new(AF_INET,SOCK_DGRAM,0)
	client.setsockopt(Socket::SOL_SOCKET,Socket::SO_REUSEADDR,true)
	sockaddr = Socket.sockaddr_in(PORT,HOST)
	client.bind(sockaddr)
end
if (!opts[:u])
	puts "tcp Proto"
	server  = Socket.new(AF_INET,SOCK_STREAM,0)
	server.setsockopt(Socket::SOL_SOCKET,Socket::SO_REUSEADDR,true)
	sockaddr = Socket.sockaddr_in(PORT,HOST)
	server.bind(sockaddr)
	server.listen(1)
	client, client_addrinfo = server.accept
end

rd = 0;
rn = 0;
begin
	loop do
 		r,_,_ = IO.select([client],nil,nil,10) 
		break unless r
		
        
        if recv_from = r.shift 
            data = recv_from.recv(BUFFER_SIZE)
            if data.empty?
				break
			end
			rn +=1;
			rd += data.length;
            file.write(data);
   		end
         
    end

rescue
	puts ERROR
    raise

ensure
  	file.close  if file
    server.close if server
    client.close if client
    puts "data recieved  = #{rd}"
	puts "data number  = #{rn}"
end

