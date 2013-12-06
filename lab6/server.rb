require 'socket'
require 'slop'
require_relative 'config'
include Socket::Constants

# @param [Array] array
def is_end(array)
  array.each do |element|
    return true if element
  end
  false
end

hash = Hash.new
opts = Slop.parse(help: false) do
  on :h, :host=, 'Host'
  on :p, :port=, 'Port'
  on :e, :ext=,  'Extension'
  on :m, :max=,  'Max number of ports'
  on :u, :udp , 'Udp'
end

number_port = opts[:m] || MAX_PORTS
host = opts[:h] || HOST
extension = opts[:e] || EXTENSION
index = 0
port  = opts[:p] || PORT
ports =port..port+number_port

begin
  files =ports.map do |p|
    file = File.open("#{OUTPUT_FILE_NAME}#{p.to_s}.#{extension}",OVERWRITE)
    file
  end

  if opts[:u]
    puts 'udp server starts'
    sockets = ports.map do |port|
      client  = Socket.new(AF_INET,SOCK_DGRAM,0)
      client.setsockopt(Socket::SOL_SOCKET,Socket::SO_REUSEADDR,true)
      sockaddr = Socket.sockaddr_in(port,host)
      client.bind(sockaddr)
      hash[client.to_s] = index
      index += 1
      client
      end
  end
  unless opts[:u]
    puts 'tcp server starts'
    sockets = ports.map do |port|
      server = Socket.new(AF_INET, SOCK_STREAM, 0)
      server.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, true)
      sockaddr = Socket.sockaddr_in(port, host)
      server.bind(sockaddr)
      server.listen(number_port)
      client,= server.accept
      hash[client.to_s] = index
      index +=1
      client
    end
  end
  receive_end = Array(number_port,false)


  loop {
    break if is_end(receive_end)
    read_stream, = IO.select(sockets,nil,nil,TIMEOUT)
    break unless read_stream
    read_stream.each do |recv_from|
      data = recv_from.recv(BUFFER_SIZE)
      index = hash[recv_from.to_s]
      receive_end[index] = true if data.empty?
      files[index].write(data)
    end
  }

rescue Interrupt
  puts 'server closing'


ensure
  files.each do |file|
    file.close
  end if files
  sockets.each do |socket|
    socket.close
  end if sockets



end

