class Game
	def initialize()
		@players={1=>nil,2=>nil,3=>nil,4=>nil}
		@mapa= [[ 0 ,'E','E','E','E','E', 1 ,'E','E','E','E','E', 0 ],
				['E', 2 , 6 , 6 ,'A','E','E','E','C', 6 , 6 , 3 ,'E'],
				['E', 7 ,'E','E','E','E','E','E','E','E','E', 7 ,'E'],
				['E', 7 ,'E','E','D','E','E','E','D','E','E', 7 ,'E'],
				['E','B','E','E', 9 ,'A','E','C', 8 ,'E','E','B','E'],
				['E','E','E','E','B','E','E','E','B','E','E','E','E'],
				['C', 6 ,'A','E','E','E', 1 ,'E','E','E','C', 6 ,'A'],
				['E','E','E','E','D','E','E','E','D','E','E','E','E'],
				['E','D','E','E', 9 ,'A','E','C', 8 ,'E','E','D','E'],
				['E', 7 ,'E','E','B','E','E','E','B','E','E', 7 ,'E'],
				['E', 7 ,'E','E','E','E','E','E','E','E','E', 7 ,'E'],
				['E', 5 , 6 , 6 ,'A','E','E','E','C', 6 , 6 , 4 ,'E'],
				[ 0 ,'E','E','E','E','E', 1 ,'E','E','E','E','E', 0 ]]
		@time=120*20
		@played=true
		@jugando=true
		@points = 112
	end
	def setPlayer(num,pl)
		@players[num]=pl
	end
	def update()
		if(@jugando)
			l=[1,2,3,4,5,6,7,8,9,'A','B','C','D']
			@players.each do|key,value|
				dir=value.nextMove()
				x=value.x()
				y=value.y()
				if(dir=="R" and (l.include? @mapa[y/50][(x+40)/50] or l.include? @mapa[(y+39)/50][(x+40)/50]))
					value.nextMove=""
				elsif (dir=="L" and (l.include? @mapa[y/50][(x-10)/50] or l.include? @mapa[(y+39)/50][(x-10)/50]))
					value.nextMove=""
				elsif(dir=="U" and (l.include? @mapa[(y-10)/50][x/50] or l.include? @mapa[(y-10)/50][(x+39)/50]))
					value.nextMove=""
				elsif(dir=="D" and (y<610 and (l.include? @mapa[(y+40)/50][x/50] or l.include? @mapa[(y+40)/50][(x+39)/50])))
					value.nextMove=""
				end
				value.update()	
			end
			comerPunto()
			timeLess()
		end
	end
	def getRow(row)
		r=""
		for i in @mapa[row]
			r+=i.to_s
		end
		return r
	end
	def getMap()
		r=""
		for i in 0..12
			for j in @mapa[i]
				r+=i.to_s
			end
		end
		return r
	end
	def timeLess()
		if(@played)
			@time-=1
		end
		if(@time==0)
			@played=false
			@jugando=false
			
		end
	end
	def time()
		r=""
		r+=(@time/1200).to_s
		r+=":"
		r+=((@time/20)%60).to_s
		return r
	end

	def points()
		return @points
	end
	def comerPunto
		@players.each do|k,v|
			r=v.y()/50
			c=v.x()/50
			dr=(v.y+39)/50
			dc=(v.x+39)/50
			if(@mapa[r][c]=='E')
				v.addPuntos()
				@mapa[r][c]=0
				@points = @points-1
			end
			if(@mapa[dr][c]=='E')
				v.addPuntos()
				@mapa[dr][c]=0
				@points = @points-1
			end
			if(@mapa[r][dc]=='E')
				v.addPuntos()
				@mapa[r][dc]=0
				@points = @points-1
			end
			if(@mapa[dr][dc]=='E')
				v.addPuntos()
				@mapa[dr][dc]=0
				@points = @points-1
			end
		end
		if (@points == 0)
			@jugando = false
		end
	end
	def jugando?()
		return @jugando
	end
	def parar()
		@jugando=false
	end
	def reanudar()
		@jugando=true
	end
end