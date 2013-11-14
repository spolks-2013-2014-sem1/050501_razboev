require 'socket'
require_relative "config.rb"
include Socket::Constants






client  = Socket.new(AF_INET,SOCK_STREAM,0)
client.setsockopt(Socket::SOL_SOCKET,Socket::SO_REUSEADDR,true)
file = File.open(INPUT_FILE_NAME, READONLY)


client.connect(Socket.sockaddr_in(PORT,HOST ))

trap('INT') do
at_axit {puts AT_EXIT}
exit
end

send_len = 0;
send_count = 0;

begin
while data = file.read(BUFFER_SIZE)
    client.write(data)
   # puts data
     send_count+=1
     send_len+=data.length
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
