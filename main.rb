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
air: State.new("Air", 130, 140),
shield: State.new("Shield", 40, 120),
power: State.new("Power", 20, 500),
rescue_time: State.new("Hours Until Rescue", rand(16..21), nil),
total_time: State.new("Total Time", 0, nil)
}

$air = $state[:air]
$shield = $state[:shield]
$power = $state[:power]
$rescue_time = $state[:rescue_time]
$total_time = $state[:total_time]

$robots = {
empty: Robot.new("Empty",true, 0),
jack: Robot.new("Jack", true, 1),
dazh: Robot.new("Dazh"),
marvin: Robot.new("Marvin"),
laneny: Robot.new("Laneney")
}

$empty = $robots[:empty]
$jack = $robots[:jack]
$dazh = $robots[:dazh]
$marvin = $robots[:marvin]
$laneny = $robots[:laneny]

$units = {
aircon: Unit.new("AirCon", true),
shieldgen: Unit.new("ShieldGen", true),
gps: Unit.new("GPS"),
beacon: Unit.new("Beacon"),
viewer: Unit.new("Viewer"),
engine: Unit.new("Engine"),
hq: Unit.new("HQ", true, 10, true),
workshop: Unit.new("Workshop", true, 1, true)
}

$aircon = $units[:aircon]
$shieldgen = $units[:shieldgen]
$gps = $units[:gps]
$beacon = $units[:beacon]
$viewer = $units[:viewer]
$engine = $units[:engine]
$hq = $units[:hq]
$workshop = $units[:workshop]

$events = {
nothing: Event.new("Nothing", 0),
air_loss: Event.new("Air Loss", 1, rand(-50..-30), 0),
meteor: Event.new("Meteor", 2, 0, rand(-20..-10)),
battery_fail: Event.new("Battery Fail", 3, 0, 0, rand(-60..-40)),
miracle: Event.new("Miracle!!!", 4, 40, 20, 60)
}

nothing = $events[:nothing]
air = $events[:air_loss]
meteor = $events[:meteor]
battery = $events[:battery_fail]
miracle = $events[:miracle]

$event_order = [
nothing,
nothing,
nothing,
nothing,
nothing,
nothing,
nothing,
air,
meteor,
battery,
nothing,
air,
battery,
miracle,
nothing,
nothing,

]


$encounter = {

}

$robots.each_value{|v| $hq.storage.push(v) if v.level >= 1}
$robots.each_value{|v| v.robot = $empty}
$robots.each_value{|v| v.unit = $hq}
$units.each_value{|v| v.robot = $empty}

#-------GAME-MACHANIZM------

$check = false

def def_check(def_name)
	puts "Def Check: #{def_name}." if $check == true
end

def help
	def_check("help")
	puts """
	q  - quit \\ Main
	m  - maintain unit or robot
	s  - send to room (Workshop or HQ)
	n  - next turn
	v  - user viewer
	v? - code list for the viewer
	rs - robot status
	ru - robot upgrade
	r? - robot help
	rr - robot reset upgrades
	us - unit status
	uu - unit upgrade
	u? - unit help
	t  - test
	t2 - test2
	"""
end

def help_robot
	def_check("help_robot")
	puts """
		..:: ROBOTS ABILITY LIST ::..
	
	>> Can maintian (m) Units and Robots.
	>> Can fix (f) Units and Robots.
	>> Can Upgrade other Robots (ru).
	"""
	puts "\t>> Jack:"
	puts "\t   Nothing special yet." if $jack.level == 1
	puts "\t   Adds +5 AIR and +2 SHIELD." if $jack.level == 2
	puts "\t   Adds +10 AIR and +4 SHIELD." if $jack.level >= 3
	puts "\t   Can Help (s) Laneny in the Workshop to Upgrade the AirCon." if $jack.level == 4
	puts ""
	puts "\t>> Dazh:"
	puts "\t   Nothing special yet." if $dazh.level == 1
	puts "\t   Hints what would be the next event." if $dazh.level >= 2
	puts "\t   Will keep an open eye for cool stuff while maintining (m) the Viewer." if $dazh.level >= 3
	puts "\t   Can Help (s) Laneny in the Workshop to Upgrade the Viewer." if $dazh.level == 4
	puts ""
	puts "\t>> Marvin:"
	puts "\t   Nothing special yet." if $marvin.level == 1
	puts "\t   Adds +5 POWER while Maintaining the Engine." if $marvin.level == 2
	puts "\t   Adds +10 POWER while Maintaining the Engine." if $marvin.level >= 3
	puts "\t   Can Help (s) Laneny in the Workshop to Upgrade the Engine." if $marvin.level == 4
	puts ""
	puts "\t>> Laneny:"
	puts "\t   When maintaining (m) the Workshop +3 AIR, +1 SHIELD and +2 POWER."
	puts "\t   When level 4 robots join (s) they help upgrade the ship's units."
	puts ""
end

def help_unit
	def_check("help_unit")
	puts "\t		..:: UNITS ABILITY LIST ::.."
	puts ""	
	puts "\t>> the AirCon losses 15 AIR every hour" if $aircon.level == 1
	puts "\t>> the AirCon is Balanced" if $aircon.level == 2
	puts "\t>> the AirCon gain 10 AIR every hour" if $aircon.level == 3
	puts ""
	puts "\t>> the ShieldGen losses 3 AIR every hour" if $shieldgen.level == 1
	puts "\t>> the ShieldGen is Balanced" if $shieldgen.level == 2
	puts "\t>> the ShieldGen gain 5 AIR every hour" if $shieldgen.level == 3	
	puts ""
	puts "\t>> the Engine losses 15 POWER every hour" if $engine.level == 1
	puts "\t>> the Engine losses 10 POWER every hour" if $engine.level == 2
	puts "\t>> the Engine losses 5 POWER every hour" if $engine.level == 3
	puts "\t>> the Engine losses 2 POWER every hour" if $engine.level == 4
	puts ""	
	puts "\t>> the Viewer Shows (v) the code of the next event, if Maintained." if $viewer.level == 1
	puts "\t>> the Viewer Shows (v) the code of the next 2 events, if Maintained." if $viewer.level == 2
	puts "\t>> the Viewer Shows (v) the code of the next 3 events, if Maintained." if $viewer.level == 3
	puts "\t   If Dazh is upgraded to level 2, and Maintaining the Viewer, he will give a heads up."
	puts """
	
	>> GPS is needed to operate the Beacon.
	
	>> Beacon is needed to help the rescue team locate the StarShip.
	
	>> HQ - Where robots go to rest
	
	>> Workshop - The place to Upgrade the ship's units.
	   :+: When Laneny is Maintaining (m) the Workshop he adds +3 AIR, +1 SHIELD, +2 POWER
	       Any other robot that Maintain (m) the Workshop adds +1 AIR, +1 SHIELD, +2 POWER 
	   :+: When Laneny is Maintaining (m) the Workshop
	       he can be assist (s) by level 4 robots to upgrade the ship's units."""		
end

def prompt
	def_check("prompt")
	puts ">> What now?"
	print ">> "
	$command = gets.chomp.downcase
	puts ""
end

def line
	def_check("line")
	puts ""
	puts "========================================"
	puts ""
end

def end_game
	def_check("end_game")
	if $air.amount <= 0 || $shield.amount <= 0
		puts ">> The Game has ENDED! You Have DIED! No worries!"
		puts ""
		exit(0)
	elsif $rescue_time.amount == 1
		puts ">> The Game had ENDED! You Have SAVED THE DAY! No worries!"
		puts ""
		exit(0)
	end		
end

def dictionary(hash)
	def_check("dictionary")
	dict = {}
	hash.each_key {|k| dict[k.to_s[0]] = k.to_s}
	dict
end

def full_list(hash, heading_text, question_text, else_text)
	def_check("full_list")
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
	def_check("robot_oper_list")
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
	def_check("upgrade_list")
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
	def_check("robot_upgrade")
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
	def_check("unit_upgrade")
	upgraded_unit = upgrade_list($units)
	upgrading_robot = robot_oper_list
	$units[upgraded_unit].robot_work($robots[upgrading_robot])
	$units[upgraded_unit].storage.push($robots[upgrading_robot])
end

def state_limit_update
	def_check("state_limit_update")
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
	def_check("robot_reset")
	robot = robot_oper_list
	$robots[robot].reset_upgrade
end
	
def fix
	def_check("fix")
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
	def_check("fix_list")
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
	def_check("maintain")
	destination = maintain_list
	robot = $robots[robot_oper_list]
	$units[destination].robot_work(robot)
end

def maintain_list
	def_check("maintain_list")
	unit_maintain_list = $units.select{|k,v| v.operative && v.level.between?(1,4)}
	unit_maintain_list_dict = dictionary(unit_maintain_list)
	
	line
	puts ""
	puts "\t    ==== M A I N T A I N ===="
	puts ""
	unit_maintain_list.each_value {|v| puts "\t:+: #{v.name} maintained by: #{v.robot.name}"}
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
	def_check("list")
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
	def_check("room_oper_list")
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
	def_check("robot_to storage")
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
	def_check("robot_status")
	robot = full_list($robots, "Full List Robots", "Which robot would you like to choose?", "No robot was selected.")
	#robot = robot_oper_list
	$robots[robot].report
end

def unit_status
	def_check("unit_status")
	unit = full_list($units, "Full List Units", "Which unit would you choose?", "No unit was selected.")
	$units[unit].report
end

def fix_status
	def_check("fix_status")
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
	def_check("view")
	if $viewer.operative && $viewer.maned
		if $viewer.level >= 1 then puts "Next hour event code: #{$event_order[0].code}" end
		if $viewer.level >= 2 then puts "In 2 hours event code: #{$event_order[1].code}" end
		if $viewer.level == 3 then puts "In 3 hours event code: #{$event_order[2].code}" end
	elsif puts "No one is in #{$viewer.name}."
	end
end

def view_code
	def_check("view")
	$events.each_value {|v| puts "?? #{v.code} - #{v.name}"}
end
	
#------SHIP-MACHANIZM------

def status
	def_check("status")
	puts ""
	puts "      	==== M A I N ===="
	puts ""
	print "	+ #{$air.name}:__________________#{$air.amount}"; print " MAX" if $air.amount == $air.limit; puts ""
	print "	+ #{$shield.name}:_______________#{$shield.amount}"; print "  MAX" if $shield.amount == $shield.limit; puts ""
	print "	+ #{$power.name}:________________#{$power.amount}"; print " MAX" if $power.amount == $power.limit; puts ""
	puts "	+ #{$rescue_time.name}:___#{$rescue_time.amount}"
	puts "	+ #{$total_time.name}:___________#{$total_time.amount}"
	puts ""
	if $viewer.robot == $dazh && $dazh.level >= 2
		if $event_order[0] == $events[:nothing] then puts ">> Dazh: We can expect a quiet hour." end
		if $event_order[0] == $events[:air_loss] then puts ">> Dazh: I see some air wooshing out from the right. We should perpare for an air loss." end
		if $event_order[0] == $events[:meteor] then puts ">> Dazh: We should brace ourself, a meteor is on his way to meet us." end
		if $event_order[0] == $events[:battery_fail] then puts ">> Dazh: One of the batteries doesn't look well to me." end
		if $event_order[0] == $events[:miracle] then puts ">> Dazh: I have good feelig about the next hour." end
	end
end

def state_limit(state)
	def_check("state_limit")
	state.amount = state.limit if state.amount > state.limit
	state.amount = 0 if state.amount < 0
end


#--------NEXT-TURN---------

def next_turn
	def_check("next")
	puts ""
	
	event_happened

	# BASE
	$air.amount -= 15 and $power.amount -= 10 if $aircon.level == 1
	$shield.amount -= 3 and $power.amount -= 5 if $shieldgen.level == 1
	$total_time.amount += 1
	
	# UPGRADEED ROBOTS EFFECT
	$air.amount += 5 and $shield.amount += 2 if $jack.level >= 2
	$air.amount += 5 and $shield.amount += 2 if $jack.level >= 3
	
	# POWER
	$power.amount += 10 if $engine.level == 1	
	$power.amount += 13 if $engine.level == 2
	$power.amount += 17 if $engine.level == 3
	$power.amount += 20 if $engine.level == 4
	$power.amount += 12 if $engine.maned
	$power.amount += 5 if $engine.operative && $engine.robot == $marvin && $marvin.level >= 2
	$power.amount += 10 if $engine.operative && $engine.robot == $marvin && $marvin.level >= 3
	
	if $power.amount > 0
		$rescue_time.amount -= 1 if $gps.operative && $beacon.operative && $beacon.maned
		
		if $aircon.operative && $aircon.maned
			if $aircon.level == 1 then $air.amount += 12 and $power.amount -= 5 end
			if $aircon.level == 2 then $power.amount += 16 end
			if $aircon.level == 3 then $air.amount += 20 and $power.amount -= 7 end
		end

		$power.amount -= 5 if $shieldgen.level == 2
		$shield.amount += 5 and $power.amount -= 5 if $shieldgen.level == 3
		$shield.amount += 3 and $power.amount -= 5 if $shieldgen.operative && $shieldgen.maned
		
		# UPGRADING in WORKSHOP
		if $workshop.robot == $laneny
			# Laneny works alone
			if $workshop.storage == [] then $air.amount += 3 and $shield.amount += 1 and $power.amount += 2 end
			
			if $workshop.storage.include?($jack)	
				
				# aircon + Jack
				if !$workshop.storage.include?($marvin) && $aircon.level < 3 
					$aircon.level += 1
					$power.amount -= 30
					if $aircon.level < 3 then puts ">> #{$aircon.name} was upgraded to level: #{$aircon.level}" end
					if $aircon.level == 3 then puts ">> #{$aircon.name} is in MAX level." end
				
				# shieldgen + Jack + Marvin
				elsif $workshop.storage.include?($marvin) && $shieldgen.level < 3
					$shieldgen.level += 1
					$power.amount -= 30
					if $shieldgen.level < 3 then puts ">> #{$shieldgen.name} was upgraded to level: #{$shieldgen.level}" end
					if $shieldgen.level == 3 then puts ">> #{$shieldgen.name} is in MAX level." end
				end	
				
			# engine + Marvin
			elsif $workshop.storage.include?($marvin) && $engine.level < 4
				$engine.level += 1
				$power.amount -= 30
				if $engine.level < 4 then puts ">> #{$engine.name} upgraded to level #{$engine.level}." end
				if $engine.level == 4 then puts ">> #{$engine.name} upgrade is MAXED." end
			
			# viewer + Dazh
			elsif $workshop.storage.include?($dazh) && $viewer.level < 3
				$viewer.level += 1
				$power.amount -= 30
				if $viewer.level < 3 then puts ">> #{$viewer.name} upgraded to level #{$viewer.level}." end
				if $viewer.level == 3 then puts ">> #{$viewer.name} upgrade is MAX." end
			
			end
			
		elsif $workshop.maned && $workshop.robot != $laneny
			$air.amount += 1
			$shield.amount += 1
			$power.amount += 1
		end
		
			# ROBOT UPGRADE
			$robots.each_value {|v| v.upgrade and $power.amount -= 20 if v.operative && v.maned}
			
				# FIX
			$robots.each_value {|v| v.fix and $power.amount -= 10 if v.operative == false && v.maned}
			$units.each_value {|v| v.fix and $power.amount -= 10 if v.operative == false && v.maned}
			$gps.robot_out if $gps.operative == true
	else
		puts "!! No power to oprate any unit."
	end
	
	state_limit($air)
	state_limit($shield)
	state_limit($power)

	end_game
end



#-----EVENTS- MACHANIZM-----



def event_happened
	def_check("event_happened")
	event_current = $event_order.shift
	event_current.effect
	puts ">> #{event_current.name} occurred."
end

#--------------- GAME !!!! --------------

$robot_dict = dictionary($robots)
$unit_dict = dictionary($units)	




def main
	def_check("main")
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
		when "r?"
			help_robot
		when "us"
			unit_status
		when "uu"
			unit_upgrade
		when "u?"
			help_unit
		when "v"
			view
		when "v?"
			view_code		
		when "slu"
			state_limit_update
		when "dc"
			$check = !$check
		when "t1"	
			$air.amount += 30
			$shield.amount += 30
			$power.amount += 60		
		when "t2"
			puts $events[:air_loss].report
			puts $events[:meteor].report
			puts $events[:battery_fail].report
		when "t3"
			puts $event_order[0].name
		when "t4"
			$jack.level += 1
		when "tl"
			test = list($robots, operative, "Those are the ROOBTS", "Which robot would you like to hug?", "It didn't work")
			puts "this: #{test}"
		else
			puts ">> Try to Type again."
		end
	end
end

main