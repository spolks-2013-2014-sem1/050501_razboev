require 'socket'
require 'slop'
require_relative "config.rb"
include Socket::Constants

opts = Slop.parse(help: false) do
  on :h, :host=, 'Host'
  on :p, :port=, 'Port'
  on :e, :ext=,  'Extension'	
end


trap('INT') do
puts AT_EXIT
exit
end

output = OUTPUT_FILE_NAME + "." +opts[:e] 

server  = Socket.new(AF_INET,SOCK_STREAM,0)
server.setsockopt(Socket::SOL_SOCKET,Socket::SO_REUSEADDR,true)
file = File.open(output, OVERWRITE)

port = opts[:p] || PORT
host = opts[:h] || HOST

sockaddr = Socket.sockaddr_in(PORT,HOST)
server.bind(sockaddr)
server.listen(1)


client, client_addrinfo = server.accept


begin
	while  data = client.read(BUFFER_SIZE)
           file.write(data)
          # puts data
    end

rescue
	puts ERROR
    raise

ensure
  	file.close  
    server.close
    client.close
end

