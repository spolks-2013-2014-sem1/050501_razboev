require 'socket'
TCPServer.open('127.0.0.1',3000) {|srvr|
if (server =srvr.accept) 
	loop{
        string  = server.gets.chomp
	server.print "#{string.reverse} \n\r"
	puts "#{string}"
        if string == "sd" 
	  server.close
	end 
	}		
end
}
