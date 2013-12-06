require 'slop'
require 'socket'
require_relative 'config'
include Socket::Constants

opts = Slop.parse(help: false) do
  on :h, :host=, 'Host'
  on :f, :file=, 'Filename'
  on :p, :port=, 'Port'
  on :u, :udp,'Udp'
end

port = opts[:p] || PORT
host = opts[:h] || HOST
filename = opts[:f] || INPUT_FILE_NAME
if opts[:u]
  puts 'udp Proto'
  client = Socket.new(AF_INET, SOCK_DGRAM, 0)
end
unless opts[:u]
  puts 'tcp Proto'
  client = Socket.new(AF_INET, SOCK_STREAM, 0)
end
client.setsockopt(Socket::SOL_SOCKET,Socket::SO_REUSEADDR,true)
client.connect(Socket.sockaddr_in(port,host ))

file = File.open(filename, READONLY)

send_data = 0
send_number = 0

begin
  while data = file.read(BUFFER_SIZE)
    _,w, = IO.select(nil,[client],nil,1)
    unless w
      break
    end
    if (send_to = w.shift)
      send_to.send(data,0)
      send_number+=1
      send_data+=data.length
      # puts data
    end
  end


rescue Interrupt
  puts 'server closing'
  raise



ensure
  client.close
  file.close
  puts "data send  = #{send_data}"
  puts "data number  = #{send_number}"
end
