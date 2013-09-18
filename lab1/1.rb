require 'socket'
srvr = TCPServer.open('127.0.0.1',3000)
while (server =srvr.accept)
        string  = server.gets.chomp
	server.print "/n/r#{string} /n/r"
	puts "#{string}"
        if string == "sd" 
	  server.close 
	end
end
