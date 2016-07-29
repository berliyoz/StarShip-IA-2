require_relative "robot"
require_relative "event"
require_relative "unit"
require_relative "state"
#require_relative "test"

=begin
  
  -++ INFO ++--
  
1. $units[:unit].room == true ===> can use storage

=end

#--------- PLAYERS -------------------

#scanner
$state = {
air: State.new("Air", 130, 1200),
shield: State.new("Shield", 140, 650),
power: State.new("Power", 10, 5000),
rescue_time: State.new("Hours Until Rescue", rand(16..21), nil),
total_time: State.new("Total Time", 0, nil)
}

$robots = {
empty: Robot.new("Empty",true, 0),
jack: Robot.new("Jack", true, 4),
dazh: Robot.new("Dazh", true, 3),
marvin: Robot.new("Marvin", true, 4),
laneny: Robot.new("Laneney", true)
}

$units = {
aircon: Unit.new("AirCon", true),
shieldgen: Unit.new("ShieldGen", true),
gps: Unit.new("GPS"),
beacon: Unit.new("Beacon"),
viewer: Unit.new("Viewer", true, 2),
engine: Unit.new("Engine"),
hq: Unit.new("HQ", true, 10, true),
workshop: Unit.new("Workshop", true, 1, true)
}


$events = {
nothing: Event.new("Nothing", 0),
air_loss: Event.new("Air Loss", 1, -40, 0),
meteor: Event.new("Meteor", 2, 0, -15),
battery_fail: Event.new("Battery Fail", 3, 0, 0, -50),
miracle: Event.new("Miracle!!!", 4, 40, 20, 60)
}


$encounter = {

}

$robots.each_value{|v| $units[:hq].storage.push(v) if v.level >= 1}
$robots.each_value{|v| v.robot = $robots[:empty]}
$robots.each_value{|v| v.unit = $units[:hq]}
$units.each_value{|v| v.robot = $robots[:empty]}

#-------GAME-MACHANIZM------

def help
	puts """
	q  - quit \ to Main
	m  - move robot
	n  - next turn
	rs - robot status
	us - unit status
	t  - test
	tt - test2
	"""
end

def prompt
	puts ">> What now?"
	print ">> "
	$command = gets.chomp.downcase
	puts ""
end

def line
	puts ""
	puts "========================================"
	puts ""
end

def end_game
	if $state[:air].amount <= 0 || $state[:shield].amount <= 0
		puts ">> The Game has ENDED! You Have DIED! No worries!"
		puts ""
		exit(0)
	elsif $state[:rescue_time].amount == 1
		puts ">> The Game had ENDED! You Have SAVED THE DAY! No worries!"
		puts ""
		exit(0)
	end		
end

def dictionary(hash)
	dict = {}
	hash.each_key {|k| dict[k.to_s[0]] = k.to_s}
	dict
end

def full_list(hash, heading_text, question_text, else_text)
	list = hash
	list_sort = list.sort
	list_dict = dictionary(list)
	
	line
	puts ""
	puts "  === #{heading_text} ==="
	puts ""
	list_sort.each {|k,v| puts "  :x: #{v.name}"}
	puts ""
	puts ">> #{question_text}"
	print ">> "
	user_input = gets.chomp.downcase
	main if user_input == "q"
	if user_input.length == 1 && list_dict.has_key?(user_input)
		output = list_dict[user_input]
	elsif list_dict.has_value?(user_input)
		output = user_input
	else
		puts ">> #{else_text}"
		puts ""
		main
	end
	output.to_sym
end

def robot_oper_list
	robot_oper_list = $robots.select{|k,v| v.operative && v.level > 0}
	robot_oper_dict = dictionary(robot_oper_list)
	line
	puts ""
	puts "  --++ Robots Oper List ++--"
	puts ""
	robot_oper_list.each {|k,v| puts "  :+: #{v.name} is in #{v.unit.name}"}
	puts ""
	puts ">> Which Robot Would you like to choose?"
	print ">> "
	user_input = gets.chomp.downcase
	main if user_input == "q"
	if user_input.length == 1 && robot_oper_dict.has_key?(user_input)
		output = robot_oper_dict[user_input]
	elsif robot_oper_dict.has_value?(user_input)
		output = user_input
	else
		puts ">> Didn't MOVE any Robot."
		main
	end
	output.to_sym
end

def upgrade_list(hash)
	list = hash.select{|k,v| v.operative && v.level.between?(1,3)}
	list_dict = dictionary(list)
	
	line
	puts ""
	puts "   == U P G R A D E   L I S T =="
	puts ""
	list.each_value{|v| puts "  :+: #{v.name}"}
	puts ""
	puts ">> Which one would you like to Upgrade?"
	print ">> "
	user_input = gets.chomp.downcase
	main if user_input == "q"
	if user_input.length == 1 && list_dict.has_key?(user_input)
		output = list_dict[user_input]
	elsif list_dict.has_value?(user_input)
		output = user_input
	else
		puts ">> Nothing was selected for Upgrade."
		main
	end
	output.to_sym
end

def robot_upgrade
	upgraded_robot = upgrade_list($robots)
	upgrading_robot = robot_oper_list
	if upgraded_robot == upgrading_robot
		puts ">> A robot can not Upgrade itsef."
		main
	else
		$robots[upgraded_robot].robot_work($robots[upgrading_robot])
	end
end

def unit_upgrade
	upgraded_unit = upgrade_list($units)
	upgrading_robot = robot_oper_list
	$units[upgraded_unit].robot_work($robots[upgrading_robot])
	$units[upgraded_unit].storage.push($robots[upgrading_robot])
end

def state_limit_update
	state = full_list($state, "State List", "Which State would you like yo Upgrade?", "No State was selected.")
	puts ">> What is the new limit?"
	user_input = gets.chomp.to_i
	if user_input == 0
		puts ">> No new limit was set."
	else
	$state[state].update(user_input)
	end
end

def robot_reset
	robot = robot_oper_list
	$robots[robot].reset_upgrade
end
	
def fix
	destination = fix_list
	robot = $robots[robot_oper_list]
	if $units.has_value?($units[destination])
		$units[destination].robot_work(robot)
	elsif $robots.has_value?($robots[destination])
		$robots[destination].robot_work(robot)
	else
		puts "??? Something went worng with  >> def fix <<"
	end
end

def fix_list
	robot_broken_list = $robots.select{|k,v| v.operative == false}
	unit_broken_list = $units.select{|k,v| v.operative == false && v.level.between?(1,4)}
	fix_list = unit_broken_list.merge(robot_broken_list)
	fix_list_dict = dictionary(fix_list)
	
	line
	puts "   ==== F I X ===="
	puts ""
	puts "     -- ROBOTS --"
	puts ""
	robot_broken_list.each_value {|v| puts "  :+: #{v.name}"}
	puts ""
	puts "     -- UNITS --"
	puts ""
	unit_broken_list.each_value {|v| puts"  :+: #{v.name}"}
	puts ""
	
	line
	puts ">> What would you like to fix?"
	print ">> "
	user_input = gets.chomp.downcase
	main if user_input == "q"
	if user_input.length == 1 && fix_list_dict.has_key?(user_input)
		output = fix_list_dict[user_input]
	elsif fix_list_dict.has_value?(user_input)
		output = user_input
	else
		puts ">> Nothing was choosen to be FIXED."
		main
	end
	output.to_sym
end

def maintain
	robot = $robots[robot_oper_list]
	destination = maintain_list
	$units[destination].robot_work(robot)
end

def maintain_list
	unit_maintain_list = $units.select{|k,v| v.operative && v.level.between?(1,4)}
	unit_maintain_list_dict = dictionary(unit_maintain_list)
	
	line
	puts ""
	puts "    ==== M A I N T A I N ===="
	puts ""
	unit_maintain_list.each_value {|v| puts ":+: #{v.name}"}
	puts ""
	puts ">> What would you like to maintain?"
	print ">> "
	user_input = gets.chomp.downcase
	main if user_input == "q"
	if user_input.length == 1 && unit_maintain_list_dict.has_key?(user_input)
		output = unit_maintain_list_dict[user_input]
	elsif unit_maintain_list_dict.has_value?(user_input)
		output = user_input
	else
		puts ">> Nothing was choosen to Maintain."
		main
	end
	output.to_sym
end	

def list(hash, selector, heading_text, question_text, else_text)
	hash_list = hash.select{|k,v| v.selector}
	hash_list_dict = dictionary(hash_list)
	
	line
	puts ""
	puts "   ==== #{heading_text} ===="
	puts ""
	hash_list.each_value {|v| puts "   :+: #{v.name}"}
	puts ""
	puts question_text
	print ">> "
	user_input = gets.chomp.downcase
	main if user_input == "q"
	if user_input.length == 1 && hash_list_dict.has_key?(user_input)
		output = hash_list_dict[user_input]
	elsif hash_list_dict.has_value?(user_input)
		output = user_input
	else
		else_text
		main
	end
	output.to_sym
end
	
def room_oper_list
	unit_list = $units.select{|k,v| v.operative && v.room == true}
	unit_list_dict = dictionary(unit_list)
	
	line
	puts ""
	puts "    ==== R O O M S ===="
	puts ""
	unit_list.each_value{|v| puts "  :+: #{v.name}"}
	puts ""
	puts ">> What unit?"
	print ">> "
	user_input= gets.chomp.downcase
	main if user_input == "q"
	if user_input.length == 1 && unit_list_dict.has_key?(user_input)
		output = unit_list_dict[user_input]
	elsif unit_list_dict.has_value?(user_input)
		output = user_input
	else
		puts ">> No unit was choosen."
		puts output
		main
	end
	
	output.to_sym
end

def robot_to_storage
	robot = robot_oper_list
	unit = room_oper_list
	if $units[unit].room == true && $units[unit].level == 1 && $robots[robot].level < 4
		puts ""
		puts ">> #{$robots[robot].name} is not in a level to help Upgrade in the Workshop."
	elsif $units[unit].storage.include?($robots[robot])
		puts ""
		puts ">> #{$robots[robot].name} is already in #{$units[unit].name}."
		
	else
		$units[unit].robot_storage_in($robots[robot])
	end
end

def robot_status
	robot = full_list($robots, "Full List Robots", "Which robot would you like to choose?", "No robot was selected.")
	#robot = robot_oper_list
	$robots[robot].report
end

def unit_status
	unit = full_list($units, "Full List Units", "Which unit would you choose?", "No unit was selected.")
	$units[unit].report
end

def fix_status
	puts ""
	puts "       FIX     "
	puts "   ---UNITS--- "
	$units.each_value {|v| puts "#{v.name} is broken." if v.operative == false && v.maned == false}
	$units.each_value {|v| puts "#{v.name} is broken. #{v.robot} will fix it in the next hour." if v.operative == false && v.maned == true}
	puts ""
	puts "  ---ROBOTS----"
	$robots.each_value {|v| puts "#{v.name} is broken." if v.operative == false }#&& v.maned == false}
	$robots.each_value {|v| puts "#{v.name} is broken. #{v.robot} will it!" if v.operative == false && v.maned == true}
	puts ""
end
	
def view
	if $units[:viewer].operative && $units[:viewer].maned
		if $units[:viewer].level >= 1 then puts "Next hour event code: #{$event_order[0].code}" end
		if $units[:viewer].level >= 2 then puts "In 2 hours event code: #{$event_order[1].code}" end
		if $units[:viewer].level == 3 then puts "In 3 hours event code: #{$event_order[2].code}" end
	elsif puts "No one is in #{$units[:viewer].name}."
	end
end

def view_code
	$events.each_value {|v| puts "?? #{v.code} - #{v.name}"}
end
	
#------SHIP-MACHANIZM------

def status
	puts ""
	puts "      	==== M A I N ===="
	puts ""
	print "	+ #{$state[:air].name}:__________________#{$state[:air].amount}"; print " MAX" if $state[:air].amount == $state[:air].limit; puts ""
	print "	+ #{$state[:shield].name}:_______________#{$state[:shield].amount}"; print "  MAX" if $state[:shield].amount == $state[:shield].limit; puts ""
	print "	+ #{$state[:power].name}:________________#{$state[:power].amount}"; print " MAX" if $state[:power].amount == $state[:power].limit; puts ""
	puts "	+ #{$state[:rescue_time].name}:___#{$state[:rescue_time].amount}"
	puts "	+ #{$state[:total_time].name}:___________#{$state[:total_time].amount}"
	puts ""
	if $units[:viewer].robot == $robots[:dazh] && $robots[:dazh].level == 4
		if $event_order[0] == $events[:nothing] then puts ">> Dazh: We can expect a quiet hour." end
		if $event_order[0] == $events[:air_loss] then puts ">> Dazh: I see some air wooshing out from the right. We should perpare for an air loss." end
		if $event_order[0] == $events[:meteor] then puts ">> Dazh: We should brace ourself, a meteor is on his way to meet us." end
		if $event_order[0] == $events[:battery_fail] then puts ">> Dazh: One of the batteries doesn't look well to me." end
		if $event_order[0] == $events[:miracle] then puts ">> Dazh: I have good feelig about the next hour." end
	end
end

def state_limit(state)
	state.amount = state.limit if state.amount > state.limit
	state.amount = 0 if state.amount < 0
end


#--------NEXT-TURN---------

def next_turn
	puts """
	"""
	
	event_happened

	#UPGRADEED ROBOTS EFFECT
	$state[:air].amount += 5 and $state[:shield].amount += 2 if $robots[:jack].level >= 2
	$state[:air].amount += 5 and $state[:shield].amount += 2 if $robots[:jack].level >= 3

	$state[:air].amount -= 20 if $units[:aircon].level == 1
	$state[:shield].amount -= 3 if $units[:shieldgen].level == 1
	
	$state[:power].amount -= 15 if $units[:engine].level == 1	
	$state[:power].amount -= 10 if $units[:engine].level == 2
	$state[:power].amount -= 5 if $units[:engine].level == 3
	$state[:power].amount -= 2 if $units[:engine].level == 4
	$state[:power].amount += 12 if $units[:engine].maned
	$state[:power].amount += 5 if $units[:engine].operative && $units[:engine].robot == $robots[:marvin] && $robots[:marvin].level >= 2
	$state[:power].amount += 10 if $units[:engine].operative && $units[:engine].robot == $robots[:marvin] && $robots[:marvin].level >= 3

	# STATE
	$state[:rescue_time].amount -= 1 if $units[:gps].operative && $units[:beacon].operative && $units[:beacon].maned
	$state[:total_time].amount += 1
	
	if $state[:power].amount > 0
		$state[:air].amount += 10 if $units[:aircon].level == 3
		$state[:air].amount += 15 if $units[:aircon].operative && $units[:aircon].maned
		

		$state[:shield].amount += 5 if $units[:shieldgen].level == 3
		$state[:shield].amount += 3 if $units[:shieldgen].operative && $units[:shieldgen].maned
		

		
		# UPGRADING in WORKSHOP
		if $units[:workshop].robot == $robots[:laneny]
			# Laneny works alone
			if $units[:workshop].storage == [] then $state[:air].amount += 3 and $state[:shield].amount += 1 and $state[:power].amount += 2 end
			
			if $units[:workshop].storage.include?($robots[:jack])	
				
				# aircon + Jack
				if !$units[:workshop].storage.include?($robots[:marvin]) && $units[:aircon].level < 3 
					$units[:aircon].level += 1
					if $units[:aircon].level < 3 then puts ">> #{$units[:aircon].name} was upgraded to level: #{$units[:aircon].level}" end
					if $units[:aircon].level == 3 then puts ">> #{$units[:aircon].name} is in MAX level." end
				
				# shieldgen + Jack + Marvin
				elsif $units[:workshop].storage.include?($robots[:marvin]) && $units[:shieldgen].level < 3
					$units[:shieldgen].level += 1
					if $units[:shieldgen].level < 3 then puts ">> #{$units[:shieldgen].name} was upgraded to level: #{$units[:shieldgen].level}" end
					if $units[:shieldgen].level == 3 then puts ">> #{$units[:shieldgen].name} is in MAX level." end
				end	
				
			# engine + Marvin
			elsif $units[:workshop].storage.include?($robots[:marvin]) && $units[:engine].level < 4
				$units[:engine].level += 1
				if $units[:engine].level < 4 then puts ">> #{$units[:engine].name} upgraded to level #{$units[:engine].level}." end
				if $units[:engine].level == 4 then puts ">> #{$units[:engine].name} upgrade is MAXED." end
			
			# viewer + Dazh
			elsif $units[:workshop].storage.include?($robots[:dazh]) && $units[:viewer].level < 3
				$units[:viewer].level += 1
				if $units[:viewer].level < 3 then puts ">> #{$units[:viewer].name} upgraded to level #{$units[:viewer].level}." end
				if $units[:viewer].level == 3 then puts ">> #{$units[:viewer].name} upgrade is MAX." end
			
			end
			
			
		elsif $units[:workshop].maned && $units[:workshop].robot != $robots[:laneny]
			$state[:air].amount += 1
			$state[:shield].amount += 1
			$state[:power].amount += 1
		end
		
			# ROBOT UPGRADE
			$robots.each_value {|v| v.upgrade if v.operative && v.maned}
			
				# FIX
			$robots.each_value {|v| v.fix if v.operative == false && v.maned}
			$units.each_value {|v| v.fix if v.operative == false && v.maned}
			$units[:gps].robot_out if $units[:gps].operative == true
	
	else
		puts "!! No power to oprate any unit."
	
	end
	
	state_limit($state[:air])
	state_limit($state[:shield])
	state_limit($state[:power])
	

	


		
	
	 
	


	end_game
end



#-----EVENTS- MACHANIZM-----

nothing = $events[:nothing]
air = $events[:air_loss]
meteor = $events[:meteor]
battery = $events[:battery_fail]
miracle = $events[:miracle]

$event_order = [air, nothing, nothing, nothing, air, meteor, battery, air, battery, nothing, nothing]

def event_happened
	event_current = $event_order.shift
	event_current.effect
	puts ">> #{event_current.name} occurred."
end

#--------------- GAME !!!! --------------

$robot_dict = dictionary($robots)
$unit_dict = dictionary($units)	




def main
	while true
		
		line
		status
		line
		prompt
		
		case $command
		when "q"
			puts "You have Quit the game."
			exit(0)
		when "?"
			help
		when "n"
			next_turn
		when "m"
			maintain
		when "f", "fix"
			fix
		when "s", "send"
			robot_to_storage
		when "ru"
			robot_upgrade
		when "rr"
			robot_reset
		when "rs"
			robot_status
		when "us"
			unit_status
		when "uu"
			unit_upgrade		
		when "v"
			view
		when "v?"
			view_code
		
		when "slu"
			state_limit_update
		when "t1"	
			$state[:air].amount += 30
			$state[:shield].amount += 30
			$state[:power].amount += 60		
		when "t2"
			a = ["yes", "no", "black", "white"]
			a2 = a.sample(2)
			puts ""
			puts a2
			puts ""
			a2 = a.sample(4)
			puts a2[2]
			puts ""
			puts a2
		when "t3"
			#view
			puts $event_order[1]
		when "t4"
			a = [1,2,3,4]
			puts "true" if a.include?(2)
			puts "also true" if not a.include?(5)
			puts "was not sepoose to be here" if not a.include?(3)
			
			
		when "tl"
			test = list($robots, operative, "Those are the ROOBTS", "Which robot would you like to hug?", "It didn't work")
			puts "this: #{test}"
		else
			puts "Try to Type again."
		end
	end
end

main