require 'socket'
require 'slop'
require_relative "config.rb"
include Socket::Constants

opts = Slop.parse(help: false) do
  on :h, :host=, 'Host'
  on :f, :file=, 'Filename'
  on :p, :port=, 'Port'
  on :u, :udp,'Udp'
end

trap('INT') do
puts AT_EXIT
exit
end

port = opts[:p] || PORT
host = opts[:h] || HOST
	
if (opts[:u])
	puts "udp Proto"
	client = Socket.new(AF_INET, SOCK_DGRAM, 0)
end
if (!opts[:u])
	puts "tcp Proto"
	client  = Socket.new(AF_INET,SOCK_STREAM,0)
end
client.setsockopt(Socket::SOL_SOCKET,Socket::SO_REUSEADDR,true)
client.connect(Socket.sockaddr_in(port,host ))

file = File.open(opts[:f], READONLY)

sd = 0
sn = 0

begin
while data = file.read(BUFFER_SIZE)
    _,w, = IO.select(nil,[client],nil,1)
    if !w 
		break
    end
	if send_to = w.shift
    	send_to.send(data,0)
		sn+=1;
		sd+=data.length;
  		# puts data
	end
end


rescue 
   puts ERROR
   raise


ensure 
   client.close
   file.close
   puts "data send  = #{sd}"
   puts "data number  = #{sn}"
end
