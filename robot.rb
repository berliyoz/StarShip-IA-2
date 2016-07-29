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
		puts """
		   --- ROBOT REPORT ---
		
			Name:  #{@name}
			Oper:  #{@operative}
			level: #{@level}
			Unit:  #{@unit.name}
			
			Fixing by: #{@robot.name}
			Maned:     #{@maned}
		"""
	end
	
	def change_unit(unit)
		if unit.room == false
			@unit.storage.delete(self)
		end
		@unit.maned = false
		@unit.robot = $robots[:empty]
		@unit = unit
	end

	def robot_work(robot)				
		
		if @robot.name == robot.name
			puts ">> #{robot.name} is already in #{@name}."
		elsif @maned == false
			@maned = true
			@robot = robot
			robot.change_unit(self)
			puts ">> #{robot.name} moved to #{@name}."
		elsif @maned == true 
			@robot.unit = $units[:hq]
			@robot = robot
			robot.change_unit(self)
			puts ">> #{robot.name} moved to hq."
		else
			puts "??? Something went wrong in >> def robot_work <<"
		end
	end
	
	def robot_out
		@robot.unit = $units[:hq]
		@robot = $robots[:empty]
		@maned = false
	end

	def fix
		@operative = true
		robot_out
		puts ">> #{@name} was fixed."
		puts ""
	end
	
	def upgrade
		@level += 1
		robot_out
		puts ">> #{@name} is now level: #{@level}."
	end

	def reset_upgrade
		@level = 1
		puts ">> #{@name} was reset and it is now level: #{@level}" 
	end
	
	
		
	
end
