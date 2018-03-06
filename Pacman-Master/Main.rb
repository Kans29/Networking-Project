require 'socket'
require 'timeout'
require 'gosu'
class Client
	def initialize(ip,port)
		@host=ip
		@port=port
		
		@numJugador=getDato(send("PLAYER"),2)
		while(@numJugador=="ERROR")
			@numJugador=getDato(send("PLAYER"),2)
		end
		puts("#{@numJugador}")
	end
	def getDato(str,i)
		str=str.chomp().split()
		if(i<str.length)
			return str[i]
		else
			return str.last
		end
	end
	def getNumJugador()
		return @numJugador
	end
	def send(messege)
		r=""
		Timeout::timeout(0.05) do
			begin
				@socket=TCPSocket.new(@host,@port)
				@socket.puts(messege)
				begin
					while line=@socket.gets
						r+= line
					end
				rescue Exception => e
					return "ERROR"
				end

				@socket.close
				return r
			rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError
				r= ("ERROR")
			end
		end
		rescue Timeout::Error
			r= "ERROR"
		return r
	end
end
class GameWindow < Gosu::Window
	def initialize()
		super(800,700,false)
    	@spritesJugadores=[Gosu::Image.new(self,"jugador1.png",false)]
    	@spritesJugadores<<Gosu::Image.new(self,"jugador2.png",false)
    	@spritesJugadores<<Gosu::Image.new(self,"jugador3.png",false)
    	@spritesJugadores<<Gosu::Image.new(self,"jugador4.png",false)
    	@estadoFont=Gosu::Font.new(20)
    	@timeFont=Gosu::Font.new(20)
    	@jugador1Font = Gosu::Font.new(20)
    	@jugador2Font = Gosu::Font.new(20)
    	@jugador3Font = Gosu::Font.new(20)
    	@jugador4Font = Gosu::Font.new(20)
    	@time="2:00"
    	@jugadoresTxt = [1=>0,2=>0,3=>0,4=>0]
    	@muroPunto=Gosu::Image.new(self,"muroPunto.png",false)
    	@muroEsq1=Gosu::Image.new(self,"muroEsq1.png",false)
    	@muroEsq2=Gosu::Image.new(self,"muroEsq2.png",false)
    	@muroEsq3=Gosu::Image.new(self,"muroEsq3.png",false)
    	@muroEsq4=Gosu::Image.new(self,"muroEsq4.png",false)
    	@muroMedIzq=Gosu::Image.new(self,"muroMedIzq.png",false)
    	@muroMedDer=Gosu::Image.new(self,"muroMedDer.png",false)
    	@muroBarH=Gosu::Image.new(self,"muroBarH.png",false)
    	@muroBarV=Gosu::Image.new(self,"muroBarV.png",false)
    	@muroExt1=Gosu::Image.new(self,"muroExt1.png",false)
    	@muroExt2=Gosu::Image.new(self,"muroExt2.png",false)
    	@muroExt3=Gosu::Image.new(self,"muroExt3.png",false)
    	@muroExt4=Gosu::Image.new(self,"muroExt4.png",false)
    	@Punto=Gosu::Image.new(self,"dot.png",false)

		@client=Client.new("192.168.250.250",3000)
		@jugadores={1=>[0,0,0],2=>[0,0,0],3=>[0,0,0],4=>[0,0,0]}
		@mapa=["","","","","","","","","","","","",""]
		@inicioX=0
		@inicioY=0
		@contador=0
		@pressedSpaceBar=false
	end
	def update
		if Gosu::button_down? Gosu::KbLeft then
			@client.send("KL #{@client.getNumJugador}")
		end
		if Gosu::button_down? Gosu::KbRight  then
			@client.send("KR #{@client.getNumJugador}")
	    end
	    if Gosu::button_down? Gosu::KbUp then
	      	@client.send("KU #{@client.getNumJugador}")
	    end
	    if Gosu::button_down? Gosu::KbDown then
	      	@client.send("KD #{@client.getNumJugador}")
	    end
	end
	def draw
		msg=@client.send("PJS")
		if(msg!="ERROR")
			msg=msg.split
			for i in 1..4
				@jugadores[i]=[msg[(i*3)-2].to_i,msg[(i*3)-1].to_i,msg[i*3].to_i]
			end
		end
		for i in 1..4
			@spritesJugadores[i-1].draw(@jugadores[i][0],@jugadores[i][1],0)
			@jugadoresTxt[i-1] = @jugadores[i][2].to_s
		end
		if(@contador==10)
			@contador=0
		end
		if(@contador==0)

			msg=@client.send("MAP")
			if(msg!="ERROR")
				msg=msg.split
				for i in 0..12
					@mapa[i]=msg[i+1]
				end				
        	end
        	msg=@client.send("ESTADO")
        	if(msg!="ERROR")
        		msg=msg.split(/\n/)
        		@estado=msg[0]
        		@time=msg[1]
        	else
        		@estado="INTENTANDO RECONECTAR"
        	end
    	end
    	for i in 0..12
    		l=@mapa[i]
	    	for j in 0..l.length-1
				if(l[j] == "1")
		         	@muroPunto.draw(@inicioX+(j*50),@inicioY+(i*50),0)
		        elsif(l[j] == "2")
		        	@muroEsq1.draw(@inicioX+(j*50),@inicioY+(i*50),0)
		        elsif(l[j] == "3")
		        	@muroEsq2.draw(@inicioX+(j*50),@inicioY+(i*50),0)
		        elsif(l[j] == "4")
		        	@muroEsq3.draw(@inicioX+(j*50),@inicioY+(i*50),0)
		        elsif(l[j] == "5")
		        	@muroEsq4.draw(@inicioX+(j*50),@inicioY+(i*50),0)
		        elsif(l[j] == "6")
		        	@muroBarH.draw(@inicioX+(j*50),@inicioY+(i*50),0)
		        elsif(l[j] == "7")
		        	@muroBarV.draw(@inicioX+(j*50),@inicioY+(i*50),0)
		        elsif(l[j] == "8")
		        	@muroMedDer.draw(@inicioX+(j*50),@inicioY+(i*50),0)
		        elsif(l[j] == "9")
		        	@muroMedIzq.draw(@inicioX+(j*50),@inicioY+(i*50),0)
		        elsif(l[j] == "A")
		        	@muroExt1.draw(@inicioX+(j*50),@inicioY+(i*50),0)
		        elsif(l[j] == "B")
		        	@muroExt2.draw(@inicioX+(j*50),@inicioY+(i*50),0)
		        elsif(l[j] == "C")
		        	@muroExt3.draw(@inicioX+(j*50),@inicioY+(i*50),0)
		        elsif(l[j] == "D")
		        	@muroExt4.draw(@inicioX+(j*50),@inicioY+(i*50),0)
		        elsif(l[j] == "E")
		        	@Punto.draw(@inicioX+(j*50),@inicioY+(i*50),0)
		        else

		        end
			end
		end
    	@estadoFont.draw(@estado,10,660,0,1.0,1.0,0xff_ffffff)
    	@timeFont.draw(@time,700,10,0,1.0,1.0,0xff_ffffff)
    	@jugador1Font.draw(@jugadoresTxt[0],300,660,0,1.0,1.0,0xff_ffffff)
    	@jugador2Font.draw(@jugadoresTxt[1],350,660,0,1.0,1.0,0xff_ffffff)
    	@jugador3Font.draw(@jugadoresTxt[2],400,660,0,1.0,1.0,0xff_ffffff)
    	@jugador4Font.draw(@jugadoresTxt[3],450,660,0,1.0,1.0,0xff_ffffff)
        puts("#{Gosu::fps}")
    	@contador+=1
	end
end
game_window=GameWindow.new()
game_window.show()