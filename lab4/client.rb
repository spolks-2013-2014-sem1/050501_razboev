require 'socket'
require_relative "config.rb"
include Socket::Constants






client  = Socket.new(AF_INET,SOCK_STREAM,0)
client.setsockopt(Socket::SOL_SOCKET,Socket::SO_REUSEADDR,true)
client.setsockopt(:SOCKET, Socket::SO_OOBINLINE, true)
file = File.open(INPUT_FILE_NAME, READONLY)

trap('INT') do
at_axit {puts AT_EXIT}
exit
end

client.connect(Socket.sockaddr_in(PORT,HOST ))



send_len = 0;
send_count = 0;

begin
while data = file.read(BUFFER_SIZE)
    _,w, = IO.select(nil,[client],nil,1)
    if !w 
		break
    end
	if send_to = w.shift
    	send_to.send(data,0)
  		# puts data
     	send_count+=1
     	send_len+=data.length
     	if send_count % MSG_COUNT == 0 
         	send_to.send(MSG_SYMBOL,Socket::MSG_OOB)
		end	
	end
end

rescue 
   puts ERROR
   raise


ensure 
   client.close
   file.close
   puts "send length = #{send_len}"
   puts "send count = #{send_count}"
end
