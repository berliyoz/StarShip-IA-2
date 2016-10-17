class Unit
	attr_accessor :name, :operative, :level, :room, :storage, :maned, :robot
	
	def initialize(name, operative = false, level = 1, room = false, storage = [], maned = false, robot = $robots[:empty])
		@name = name
		@operative = operative
		@level = level
		@room = room
		@storage = storage
		@maned = maned
		@robot = robot
	end
	
	def report
		def_check("report")
		puts """
		 --++ #{@name} ++--
		  
		Operative:_#{@operative}
		Maned:_____#{@maned}
		Robot:_____#{@robot.name}
		Level:_____#{@level}"""
	
		if @storage == []
			puts "		Storage:___Empty"
		else 
			print "		Storage:___"
			storage_list = []
			@storage.each {|v| storage_list.push(v.name)}
			print storage_list
			puts ""
		end
		STDIN.gets
	end

	def breakdown
		def_check("breakdown")
		@operative = false if @operative == true
		puts "#{@name} malfunction."
		puts "#{@robot} will fix it in the next hour." if @maned == true
		puts "There is no Robot attending this unit." if @maned == false
	end
	
	def fix
		def_check("fix")
		@operative = true
		$power.amount += $power_amount[:fix]
		puts "\t<< #{@name} was fixed. >>"
	end

	def robot_out
		def_check("robot_out")
		@robot.unit = $units[:hq]
		robot_storage_out
		@robot = $robots[:empty]
		@maned = false
	end
		
	def robot_storage_in(robot)
		def_check("robot_storage_in")
		if robot.unit.storage.include?(robot) then robot.unit.storage.delete(robot) end 
		@storage.push(robot)
		robot.change_unit(self)
		puts ""
		puts ">> #{robot.name} moved to #{@name}."
		puts ""
	end	
	
	def robot_work(robot)
		def_check("robot_out")	
		if @robot.name == robot.name
			puts "\t<< #{robot.name} is already in #{@name}. >>"
		elsif @maned == false
			if robot.unit.storage.include?(robot) then robot.unit.storage.delete(robot) end
			@maned = true
			@robot = robot
			robot.change_unit(self)
			puts "\t<< #{robot.name} moved to #{@name}. >>"
		elsif @maned == true 
			puts "\t<< #{@robot.name} moved to #{$units[:hq].name}.>>"
			@robot.unit = $units[:hq]
			puts "\t<< #{robot.name} moved to #{@name}.>>"
			@robot = robot
			robot.change_unit(self)
			
		else
			puts "??? Something went wrong in >> def robot_work <<"
		end
	end

	def robot_storage_out
		def_check("robot_storage_out")
		@storage.delete(@robot) if @storage.include?(@robot)

	end
	
	def upgrade
		def_check("upgrade")
		@level += 1
		robot_storage_out
		robot_out
		puts "\t<< #{@name} is now level: #{@level}. >>"
	end
	
end
		