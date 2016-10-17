class Robot
	attr_accessor :name, :operative, :level, :unit, :maned, :robot, :room
	
	def initialize(name, operative = false, level = 1, unit = nil, maned = false, robot = nil, room = false)
		@name = name
		@operative = operative
		@level = level
		@unit = unit
		@maned = maned
		@robot = robot
		@room = room
	end

	def report
		def_check("report")
		puts """
		   --- ROBOT REPORT ---
		
			Name:  #{@name}
			Oper:  #{@operative}
			Level: #{@level}
			Unit:  #{@unit.name}
			
			Fixer: #{@robot.name}
			Maned: #{@maned}
		"""
		STDIN.gets
	end
	
	def change_unit(unit)
		def_check("change_unit")
		if unit.room == false
			@unit.storage.delete(self)
		end
		@unit.maned = false
		@unit.robot = $robots[:empty]
		#@unit.storage.push(self) --- solved the problem of not going back to HQ
		@unit = unit
	end

	def robot_work(robot)
		def_check("robot_work")
		
		if @robot.name == robot.name
			puts "\t<< #{robot.name} is already in #{@name}. >>"
		elsif @maned == false
			@maned = true
			@robot = robot
			robot.change_unit(self)
			puts "\t<< #{robot.name} working on #{@name}. >>"
		elsif @maned == true 
			@robot.unit = $units[:hq]
			@robot = robot
			robot.change_unit(self)
			puts "\t<< #{robot.name} moved to hq. >>"
		else
			puts "??? Something went wrong in >> def robot_work <<"
		end
	end
	
	def robot_out
		def_check("robot_out")
		@robot.unit = $units[:hq]
		@robot = $robots[:empty]
		@maned = false
	end

	def fix
		def_check("fix")
		if $power.amount >= $power_amount[:fix]
			@operative = true
			robot_out
			$power.amount += $power_amount[:fix]
			puts "\t<< #{@name} was fixed. >>"
		else
			puts "\t<< Not enough POWER to fix. >>"
		end
	end
	
	def upgrade
		def_check("upgrade")
		@level += 1
		robot_out
		$power.amount += $power_amount[:upgrade]
		puts "\t<< #{@name} is now level: #{@level}. >>"
	end

	def reset_upgrade
		def_check("reset_upgrade")
		@level = 1
		puts "\t<< #{@name} was reset and it is now level: #{@level} >>" 
	end
	
	
		
	
end
