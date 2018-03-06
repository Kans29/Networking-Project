require "socket"
require_relative "Player"
require_relative "Game"
class Server
	def initialize(ip,port)
		@server=TCPServer.open(ip,port)
		@host=ip
		@port=port
    	puts "Servidor corriendo en #{ip} en el puerto #{port}"
		@jugadores={1=>Player.new(1,0,0),2=>Player.new(2,610,0),3=>Player.new(3,0,610),4=>Player.new(4,610,610)}
    	@numJugadores=0
    	@game=Game.new()
    	listen()
    end
    def listen
    	loop do
            begin
            
                client=@server.accept
                msg=client.gets
                if(msg!=nil)
                    msg=msg.chomp()
                    res=responder(msg)
                    client.puts(res)
                end
                client.close()
            rescue Exception => e
            end

    	end
    end
    def responder(msg)
    	msgs=msg.split()
    	if(msgs[0]=="PLAYER")
    		if(@numJugadores<4)
    		@numJugadores+=1
    		puts("Entro jugardor #{@numJugadores}")
    		if(@numJugadores==4)
    			puts("comenzo juego")
    			jugar()
    		end
    		return "ENTER J "+@numJugadores.to_s
    		else
    			return "FULL"
    		end
 		elsif (msgs[0]=="KL")
 			@jugadores[msgs[1].to_i].nextMove="L"
 		elsif (msgs[0]=="KR")
 			@jugadores[msgs[1].to_i].nextMove="R"
 		elsif (msgs[0]=="KU")
 			@jugadores[msgs[1].to_i].nextMove="U"
 		elsif (msgs[0]=="KD")
 			@jugadores[msgs[1].to_i].nextMove="D"
    	elsif (msgs[0]=="PJ")
    		return "PJ #{msgs[1]} #{@jugadores[msgs[1].to_i].x} #{@jugadores[msgs[1].to_i].y} #{@jugadores[msgs[1].to_i].Puntos}"
    	elsif(msgs[0]=="ROW")
    		return "ROW #{msgs[1]} #{@game.getRow(msgs[1].to_i)}"
    	elsif (msgs[0]=="MAP")
            r="MAP"
            for i in 0..12
                r+=" "+@game.getRow(i)
            end
    		return r
        elsif (msgs[0]=="PJS")
            r="PJS"
            for i in 1..4
                r+=" #{@jugadores[i].x} #{@jugadores[i].y} #{@jugadores[i].Puntos}"
            end
            return r
        elsif (msgs[0]=="ESTADO")
            if(@numJugadores==4)
                if(@game.jugando?)
                    r="JUGANDO"
                else
                    if(@game.time=="0:0")
                        r="JUEGO TERMINADO"
                    elsif (@game.points == 0)
                        r ="JUEGO TERMINADO"
                    else
                        r="PARADO"
                    end
                end
            else
                r="esperando jugadores"
                for i in (@numJugadores+1)..4
                    r+=" "+i.to_s
                end
            end
            r+="\n"+@game.time()
            return r
        elsif(msgs[0]=="PARAR")
            @game.parar()
            puts("juego parado")
        elsif (msgs[0]=="REANUDAR")
            @game.reanudar()
            puts("juego reanudado")
        end
    	return msg
    end
    def jugar()
    	@game=Game.new()
    	1.upto(4) do |i|
      	@game.setPlayer(i,@jugadores[i])
    	end
    	Thread.new do
      		while true do
       			@game.update()
        		sleep 0.05
      		end
    	end
  	end
end
Server.new(Socket.ip_address_list[1].inspect_sockaddr,3000)