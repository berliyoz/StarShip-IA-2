require_relative "robot"
require_relative "event"
require_relative "unit"
require_relative "state"
require_relative "story"

$check = false
def def_check(def_name)
	puts "Def Check: #{def_name}." if $check == true
end

#def find(good_event)
#	def_check("find")
#	if $viewer.robot == $dazh && $dazh.level == 3
#		return good_event
#	else 
#		$nothing
#	end
#end

=begin
  -++ INFO ++--
1. $units[:unit].room == true ===> can use storage

=end
$story_counter = State.new("Story Counter", 0, nil)

def int_game

#scanner
$state = {
air: State.new("Air", 110, 140),
shield: State.new("Shield", 60, 120),
power: State.new("Power", 50, 500),
rescue_time: State.new("Hours Until Rescue", rand(16..21), nil),
total_time: State.new("Total Time", 0, nil)
}

$air = $state[:air]
$shield = $state[:shield]
$power = $state[:power]
$rescue_time = $state[:rescue_time]
$total_time = $state[:total_time]

$air_amount = {
base: -15,
jack_l_2: 5,
jack_l_3: 6,
aircon_l_1_maned: 12,
aircon_l_3_maned: 20,
workshop_laneny: 3,
workshop_robot: 1
}

$shield_amount = {
base: -3,
jack_l_2: 2,
jack_l_3: 2,
shieldgen_l_3: 5,
shieldgen_maned: 3,
workshop_laneny: 1,
workshop_robot: 1,
}

$power_amount = {
base: -15,
level_1: 10,
level_2: 13,
level_3: 17,
level_4: 20,
maned: 12,
marvin_2: 6,
marvin_3: 10,
aircon_l_1: -5,
aircon_l_2: -6,
aircon_l_3: -7,
shieldgen: -2,
shield_maned: -5, 
workshop_laneny: 2,
workshop_robot: 1,
upgrade: -30,
fix: -10
}

$robots = {
empty: Robot.new("Empty",true, 0),
jack: Robot.new("Jack", true,),
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
nothing: Event.new("Nothing", 0, 0, 0, 0, 0, ">> Dazh: We can expect a quiet hour."),
air_loss: Event.new("Air Loss", 1, rand(-50..-30), 0, 0, 0, ">> Dazh: I see some air wooshing out from the right. We should perpare for an air loss."),
meteor: Event.new("Meteor", 2, 0, rand(-20..-10), 0, 0, ">> Dazh: We should brace ourself, a meteor is on his way to meet us."),
battery_fail: Event.new("Battery Fail", 3, 0, 0, rand(-60..-40), 0, ">> Dazh: One of the batteries doesn't look well to me."),
miracle: Event.new("Miracle!!!", 4, 40, 20, 60, 0, ">> Dazh: I have good feelig about the next hour."),
air_balloon: Event.new("Air Balloon", 5, 20, 0, 0, 0, ">> Dazh: I can see an Air Balloon floating our way. Hopefully I can catch it."),
battery_found: Event.new("Good Battery Magic", 6, 0, -5, rand(30..40), 0, ">> Dazh: A half working stalite is going to bump us. I might be able to get some Power from it.")
}

$nothing = $events[:nothing]
$air_loss = $events[:air_loss]
$meteor = $events[:meteor]
$bat_loss = $events[:battery_fail]
$miracle = $events[:miracle]
$balloon = $events[:air_balloon]
$bat_found = $events[:battery_found]

$event_order = []

def events_array
	def_check("events_array")
	event_list_chance = []
	4.times {$event_order.push($nothing)}
	
	10.times {event_list_chance.push($nothing)}
	5.times {event_list_chance.push($air_loss)}
	4.times {event_list_chance.push($meteor)}
	5.times {event_list_chance.push($bat_loss)}
	2.times {event_list_chance.push($miracle)}
	2.times {event_list_chance.push($balloon)}
	2.times {event_list_chance.push($bat_found)}
	
	200.times {$event_order.push(event_list_chance[rand(0...event_list_chance.length)])}
end

$robots.each_value{|v| $hq.storage.push(v) if v.level >= 1}
$robots.each_value{|v| v.robot = $empty}
$robots.each_value{|v| v.unit = $hq}
$units.each_value{|v| v.robot = $empty}

events_array

end

def help
	def_check("help")
	puts """
	    ..:: HELP ::..
	
	q  - quit \\ Main
	c  - credits
	t? - program checking tools
	
	m  - maintain unit or robot
	s  - send to room (Workshop or HQ)
	n  - next turn

	r? - robot help
	rf - robot fix
	ru - robot upgrade
	
	u? - unit help
	ui - unit info
	uf - unit fix
	"""
	if $story_counter.amount == 5 then puts "\tp?  - party_invitation" and puts "" end
end

def help_robot
	def_check("help_robot")
	puts """
		..:: ROBOTS ABILITY LIST ::..
	
	>> Can maintian (m) Units and Robots.
	>> Can fix Units (uf) and Robots (rf).
	>> Can Upgrade other Robots (ru).
	"""
	puts "\t>> Jack:   (Level: #{$jack.level}, in Unit: #{$jack.unit.name})"
	puts "\t   Nothing special yet." if $jack.level == 1
	puts "\t   Adds #{$air_amount[:jack_l_2]} AIR and #{$shield_amount[:jack_l_2]} SHIELD." if $jack.level == 2
	puts "\t   Adds #{$air_amount[:jack_l_2] + $air_amount[:jack_l_3]} AIR and #{$shield_amount[:jack_l_2] + $shield_amount[:jack_l_3]} SHIELD." if $jack.level >= 3
	puts "\t   Can Help (s) Laneny in the Workshop to Upgrade the AirCon." if $jack.level == 4
	puts ""
	puts "\t>> Dazh:   (Level: #{$dazh.level}, in Unit: #{$dazh.unit.name})"
	puts "\t   Nothing special yet." if $dazh.level == 1
	puts "\t   Hints what would be the next event." if $dazh.level >= 2
	puts "\t   Will keep an open eye for cool stuff while maintining (m) the Viewer." if $dazh.level >= 3
	puts "\t   Can Help (s) Laneny in the Workshop to Upgrade the Viewer." if $dazh.level == 4
	puts ""
	puts "\t>> Marvin: (Level: #{$marvin.level}, in Unit: #{$marvin.unit.name})"
	puts "\t   Nothing special yet." if $marvin.level == 1
	puts "\t   Adds #{$power_amount[:marvin_2]} POWER while Maintaining the Engine." if $marvin.level == 2
	puts "\t   Adds #{$power_amount[:marvin_2]} POWER while Maintaining the Engine." if $marvin.level >= 3
	puts "\t   Can Help (s) Laneny in the Workshop to Upgrade the Engine." if $marvin.level == 4
	puts ""
	puts "\t>> Laneny: (LevelL #{$laneny.level}, in  Unit: #{$laneny.unit.name})"
	puts "\t   When maintaining (m) the Workshop Adds: #{$air_amount[:workshop_laneny]} AIR, #{$shield_amount[:workshop_laneny]} SHIELD and #{$power_amount[:workshop_laneny]} POWER."
	puts "\t   When level 4 robots join (s) they help upgrade the ship's units."
	puts ""
end

def help_unit
	def_check("help_unit")
	puts "\t\t\t..:: UNITS ABILITY LIST ::.."
	puts ""	
	puts "\t>> Humens:    Losses #{$air_amount[:base] * -1} AIR every hour" if $aircon.level == 1
	puts "\t>> ShieldGen: Losses #{$shield_amount[:base] * -1} SHIELD every hour" if $shieldgen.level == 1
	puts "\t>> Engine:    Uses #{$power_amount[:base] * -1} POWER every hour"
	puts ""
	puts "\t\t\t     ..:: IF MANED ::.."
	puts ""
	puts "\t>> AirCon:    Gain #{$air_amount[:aircon_l_1_maned]} AIR every hour" if $aircon.level == 1
	puts "\t>> AirCon:    Balanced" if $aircon.level == 2
	puts "\t>> AirCon:    Gain #{$air_amount[:aircon_l_3_maned]} AIR every hour" if $aircon.level == 3
	puts "\t>> ShieldGen: Gain #{$shield_amount[:shieldgen_maned]} SHIELD every hour" if $shieldgen.level == 1
	puts "\t>> ShieldGen: Balanced" if $shieldgen.level == 2
	puts "\t>> ShieldGen: Gain #{$shield_amount[:shieldgen_l_3]} SHIELD every hour" if $shieldgen.level == 3	
	puts "\t>> Engine:    Generate #{$power_amount[:level_1]} POWER every hour" if $engine.level == 1
	puts "\t>> Engine:    Generate #{$power_amount[:level_2]} POWER every hour" if $engine.level == 2
	puts "\t>> Engine:    Generate #{$power_amount[:level_3]} POWER every hour" if $engine.level == 3
	puts "\t>> Engine:    Generate #{$power_amount[:level_4]} POWER every hour" if $engine.level == 4
	puts "\t>> Viewer:    If Dazh is upgraded to level 2, and Maintaining the Viewer, he will give a heads up."
puts """
	>> Beacon is needed to help the rescue team locate the StarShip. (GPS is needed to operate the Beacon.)
	>> HQ - Where robots go to rest
	>> Workshop - The place to Upgrade the ship's units.
	   :+: When Laneny is Maintaining (m) the Workshop he adds #{$air_amount[:workshop_laneny]} AIR, #{$shield_amount[:workshop_laneny]} SHIELD and #{$power_amount[:workshop_laneny]} POWER.
	       Any other robot that Maintain (m) the Workshop adds #{$air_amount[:workshop_robot]} AIR, #{$shield_amount[:workshop_robot]} SHIELD and #{$power_amount[:workshop_robot]} POWER.
	   :+: When Laneny is Maintaining (m) the Workshop
	       he can be assist (s) by level 4 robots to upgrade the ship's units."""		
end

def help_program
	def_check("help_program")
	puts """
	   ..:: PROGRAM TESTING TOOLS ::..
	   
	dc  - def check (turn on \ off)

	ri - robot info
	rs  - robot status
	rr  - robot reset upgrades

	us  - unit status

	sr  - state report
	slu - set new state limit
	sb  - state boost

	t   - test
	t2  - test 2
	t3  - test 3
	"""
end

def credits
	def_check("credits")
	puts """
		..:: CREDITS ::..
		
	Programmer:  Barak Ben Dov
	Cool Lady:   L.E.T Mino	
	Master Grip: Simha Talalayevsky
	Guru:        Nadav Ben Dov

	
	
	
	  Summer of 2016"""
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
		puts """
		
		
                        ..................          .........          .....
                    ................................................................
                  .....................................................................
                ....... The Game had ENDED! You DIED! No worries! .......................
            .....................................................................................
                  ..................              ................          .........
				 
				 


				 
				 
		 
		
		"""
		exit(0)
	elsif $rescue_time.amount == 1
		puts """
		
		
                       ..................          .........          .....
                   ...............................................................
                .....................................................................
              ....... The Game had ENDED! You Have SAVED THE DAY! No worries! ............
          .....................................................................................
                 ..................              ................          .........
				 
				 


				 
				 
		* now go have some fun in the party.
		
		"""
		exit(0)
	end		
end

def dictionary(hash)
	def_check("dictionary")
	dict = {}
	hash.each_key {|k| dict[k.to_s[0]] = k.to_s}
	dict
end

def state_limit_update
	def_check("state_limit_update")
	state = list($state, "full", nil, nil, "State List", ">>Which State would you like to Update?", ">> No State was selected.", nil)
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
	robot = list($robots, "between", 2, 4, "ROBOT RESET", ">>Which Robot would you like to Reset?", ">> No robots was selected.", ">> No Robots to select.")
	$robots[robot].reset_upgrade
end

def robot_to_work
	def_check("robot_to_work")
	robot = list($robots, "between", 1, 4, "AVAILABLE ROBOTS", ">> Which Robot would you like to assign for the job?", "No Robot was selected.", ">> All Robots are Broken.")
	return robot
end

def robot_upgrade
	def_check("robot_upgrade")
	worker = robot_to_work
	work = list($robots, "between", 1, 3, "ROBOTS UPGRADE", ">> Which Robot would you like to  upgrade?", ">> No Robots was selected.", ">> All Robots are at MAX level.")
	if work == worker then puts "\t<< A robot cannot Upgrade itsef. >>"; main end
	$robots[work].robot_work($robots[worker])
end

def robot_fix
	def_check("robot_fix")
	worker = robot_to_work
	work = list($robots, "oper_false", nil, nil, "BROKEN ROBOTS", ">> Which Robot would you like to Fix?", ">> No Robot was selected.", ">> All Robots are Operational.")
	$robots[work].robot_work($robots[worker])
end

def unit_fix
	def_check("unit_fix")
	worker = robot_to_work
	work = list($units, "oper_false", nil, nil , "BROKEN UNITS", ">> Which Unit would you like to Fix?", ">> No Unit was selescted.", ">> ALL Units are Operational.")
	$units[work].robot_work($robots[worker])
end

def maintain
	def_check("maintain")
	worker = robot_to_work
	work = list($units, "between", 1, 4, "OPERATIONAL UNITS", ">> Which Unit would you like to Maintain?", ">> No unit was selected.", ">> All Units are Broken.")
	$units[work].robot_work($robots[worker])
end

def robots_info
	def_check("robot_info")
	list = $robots.select{|k,v| v.level >= 1}
	puts "\t..:: ROBOT INFO LIST ::.."
	puts ""
	list.each_value{|v| puts "\t- (Level: #{v.level}) #{v.name} in Unit: #{v.unit.name}."}
end

def units_info
	def_check("unit_info")
	list = $units.select{|k,v| v.level <= 4}
	list_hq = $robots.select{|k,v| v.unit == $hq && v.level > 0}
	list_workshop = $robots.select{|k,v| v.unit == $workshop && v.level > 0}
	puts "\t..:: UNITS INFO LIST ::.."
	puts ""
	list.each_value{|v| puts ":+: #{v.name}: #{v.level}, #{v.robot.name}."}
	puts ""
	puts "\t    ..:: HQ ::.."
	puts ""
	if $hq.storage == [] then puts ":+: There are no Robots Resting in HQ." end
	list_hq.each_value{|v| print ":+: #{v.name}  "}
	puts ""
	puts ""
	puts "\t ..:: Workshop ::.."
	if $workshop.storage == [] then puts "\n:+: There are no Robots Helping in the Workshop." end
	list_workshop.each_value{|v| print "   :+: #{v.name} "}
	puts ""
	
	end

def list(hash, selector, val_1, val_2, heading_text, question_text, else_text, empty)
	def_check("list")
	case selector
	when "full"
		list = hash
	when "oper_true"
		list = hash.select{|k,v| v.operative}
	when "oper_false"
		list = hash.select{|k,v| v.operative == false && v.room == false}
	when "between"
		list = hash.select{|k,v| v.operative && v.level.between?(val_1, val_2)}
	when "room"
		list = $units.select{|k,v| v.operative && v.room == true}
	end

	if list == {} then puts empty; main end
	list.sort
	list_dict = dictionary(list)
	
	line
	puts ""
	puts "   ==== #{heading_text} ===="
	puts ""
	list.each_value {|v| puts "   :+: #{v.name}"}
	puts ""
	puts question_text
	print ">> "
	user_input = gets.chomp.downcase
	main if user_input == "q"
	if user_input.length == 1 && list_dict.has_key?(user_input)
		output = list_dict[user_input]
	elsif list_dict.has_value?(user_input)
		output = user_input
	else
		else_text
		main
	end
	output.to_sym
end
	
def robot_to_storage
	def_check("robot_to storage")
	robot = list($robots, "between", 1, 4, "AVAILABLE ROBOTS", ">> Which Robot would you like to Send?", ">> No Robot was selected.", nil)
	unit = list($units, "room", nil, nil, "AVAILABLE ROOMS", ">> Which Room would you like to choose?", ">> No Room was selected.", nil) 
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
	robot = list($robots, "full", nil, nil, "Full List Robots", "Which robot would you like to choose?", "No robot was selected.", nil)
	$robots[robot].report
end

def unit_status
	def_check("unit_status")
	unit = list($units, "full", nil, nil, "Full List Units", "Which unit would you choose?", "No unit was selected.", nil)
	$units[unit].report
end

#------SHIP-MACHANIZM------

def party
	if $story_counter.amount == 5
		party_invitation
	else
		puts "\t>> What Party?"
	end
end

def status
	def_check("status")
	puts " ? - help       ==== M A I N ===="
	puts ""
	print "	+ #{$air.name}:__________________#{$air.amount}"; print " MAX" if $air.amount == $air.limit; puts ""
	print "	+ #{$shield.name}:_______________#{$shield.amount}"; print " MAX" if $shield.amount == $shield.limit; puts ""
	print "	+ #{$power.name}:________________#{$power.amount}"; print " MAX" if $power.amount == $power.limit; puts ""
	if $beacon.operative && $gps.operative then puts "	+ #{$rescue_time.name}:___#{$rescue_time.amount}" end
	puts "	+ #{$total_time.name}:___________#{$total_time.amount}"
	puts ""
	robots_info
	
	
	if $viewer.robot == $dazh && $dazh.level > 1 then puts $event_order[0].dazh_message end
end


def state_limit(state)
	def_check("state_limit")
	state.amount = state.limit if state.amount > state.limit
	state.amount = 0 if state.amount < 0
end

def state_report
	puts "\t --== ALL STATE REPORT ==--"
	puts ""
	$state.each_value {|v| puts "?? #{v.name}: #{v.amount}...#{v.limit}(MAX)"}
end

#--------NEXT-TURN---------

def next_turn
	def_check("next")
	puts ""
	
	#$good_event = find($balloon)
	event_happened

	# BASE
	$air.amount += $air_amount[:base]
	$shield.amount += $shield_amount[:base]
	$power.amount += $power_amount[:base]
	$total_time.amount += 1
	
	# UPGRADEED ROBOTS EFFECT
	$air.amount += $air_amount[:jack_l_2] and $shield.amount += $shield_amount[:jack_l_2] if $jack.level >= 2
	$air.amount += $air_amount[:jack_l_3] and $shield.amount += $shield_amount[:jack_l_3] if $jack.level >= 3
	
	# POWER
	$power.amount += $power_amount[:level_1] if $engine.level == 1	
	$power.amount += $power_amount[:level_2] if $engine.level == 2
	$power.amount += $power_amount[:level_3] if $engine.level == 3
	$power.amount += $power_amount[:level_4] if $engine.level == 4
	$power.amount += $power_amount[:maned] if $engine.maned
	$power.amount += $power_amount[:marvin_2] if $engine.operative && $engine.robot == $marvin && $marvin.level >= 2
	$power.amount += $power_amount[:marvin_3] if $engine.operative && $engine.robot == $marvin && $marvin.level >= 3
	
	if $power.amount > 0
		if $gps.operative && $beacon.operative && $beacon.maned then $rescue_time.amount -= 1 end
		
		# AIR		
		if $aircon.operative && $aircon.maned
			if $aircon.level == 1 then $power.amount += $power_amount[:aircon_l_1] and $air.amount += $air_amount[:aircon_l_1_maned] end
			if $aircon.level == 2 then $power.amount += $power_amount[:aircon_l_2] end
			if $aircon.level == 3 then $power.amount += $power_amount[:aircon_l_3] and $air.amount += $air_amount[:aircon_l_3_maned] end
		end
		
		# SHIELD
		if $shieldgen.level >= 2 then $power.amount += $power_amount[:shieldgen] and $shield.amount += $shield_amount[:base] * -1 end
		if $shieldgen.level == 3 then $shield.amount += $shield_amount[:shieldgen_l_3] end
		if $shieldgen.operative && $shieldgen.maned then $power.amount += $power_amount[:shieldgen] and $shield.amount += $shield_amount[:shieldgen_maned] end
		
		# UPGRADING in WORKSHOP
		if $workshop.robot == $laneny
			# Laneny works alone
			if $workshop.storage == [] then $air.amount += $air_amount[:workshop_laneny] and $shield.amount += $shield_amount[:workshop_laneny] and $power.amount += $power_amount[:workshop_laneny] end
			
			if $workshop.storage.include?($jack)	
				
				# aircon + Jack
				if !$workshop.storage.include?($marvin) && $aircon.level < 3 
					$aircon.level += 1
					$power.amount += $power_amount[:upgrade]
					if $aircon.level < 3 then puts ">> #{$aircon.name} was upgraded to level: #{$aircon.level}" end
					if $aircon.level == 3 then puts ">> #{$aircon.name} is in MAX level." end
				
				# shieldgen + Jack + Marvin
				elsif $workshop.storage.include?($marvin) && $shieldgen.level < 3
					$shieldgen.level += 1
					$power.amount += $power_amount[:upgrade]
					if $shieldgen.level < 3 then puts ">> #{$shieldgen.name} was upgraded to level: #{$shieldgen.level}" end
					if $shieldgen.level == 3 then puts ">> #{$shieldgen.name} is in MAX level." end
				end	
				
			# engine + Marvin
			elsif $workshop.storage.include?($marvin) && $engine.level < 4
				$engine.level += 1
				$power.amount += $power_amount[:upgrade]
				if $engine.level < 4 then puts ">> #{$engine.name} upgraded to level #{$engine.level}." end
				if $engine.level == 4 then puts ">> #{$engine.name} upgrade is MAXED." end
			
			# viewer + Dazh
			elsif $workshop.storage.include?($dazh) && $viewer.level < 3
				$viewer.level += 1
				$power.amount += $power_amount[:upgrade]
				if $viewer.level < 3 then puts ">> #{$viewer.name} upgraded to level #{$viewer.level}." end
				if $viewer.level == 3 then puts ">> #{$viewer.name} upgrade is MAX." end
			
			end
			
		elsif $workshop.maned && $workshop.robot != $laneny
			$air.amount += $air_amount[:workshop_robot]
			$shield.amount += $shield_amount[:workshop_robot]
			$power.amount += $power_amount[:workshop_robot]
		end
		
			# ROBOT UPGRADE
			$robots.each_value {|v| if v.operative && v.maned then v.upgrade end}
			
			# FIX
			$robots.each_value {|v| if v.operative == false && v.maned then v.fix end}
			$units.each_value {|v|  if v.operative == false && v.maned then v.fix end}
			$gps.robot_out if $gps.operative == true
	else
		puts "\t<< No power to oprate any unit! >>"
	end
	
	state_limit($air)
	state_limit($shield)
	state_limit($power)
	
	# PARTY STORY
	
	if $story_counter.amount == 4 && $hq.storage.include?($jack) && $hq.storage.include?($marvin) && $hq.storage.include?($dazh) && $hq.storage.include?($laneny) then story_party end
	if $story_counter.amount == 3 && $workshop.robot == $jack then story_found end
	if $story_counter.amount.between?(1,2) && $workshop.robot == $jack then $story_counter.amount += 1 end
	if $story_counter.amount == 0 && $jack.level > 2 && $rescue_time.amount.between?(5,10) then story_check end
	
	end_game
end

#-----EVENTS- MACHANIZM-----

def event_happened
	def_check("event_happened")
	event_current = $event_order.shift

	case event_current
	when $balloon
		if $dazh.level == 3 && $viewer.robot == $dazh then event_current = $balloon and puts "\t>> Dazh: I found an Air Balloon floating our way." else event_current = $nothing end
		##puts "1"
	when $bat_found
		##puts "2"
		if $dazh.level == 3 && $viewer.robot == $dazh then event_current = $bat_found and puts "\t>> Dazh: Luck is on our favor. I found an Extre battery." else event_current = $nothing end
	end
	
	case event_current
	when $nothing
		puts "\t<< Another quiet hour. >>"
	when $air_loss
		puts "\t<< In the last hour we have lost some Air. >>"
	when $meteor
		puts "\t<< In the last hour we suffered from a Meteor hit. >>"
	when $miracle
		puts "\t<< This old ship manged to juiced up a little!!! >>"
	end

	event_current.effect
end

#--------------- GAME !!!! --------------

def main_game_screen
	def_check("main_game_screen")
	while true
	
		line
		main_game_screen_message
		line
		prompt
		
		case $command
		when "s"
		int_game
		story_start
		when "q"
		puts "\t<< You have Quit the game.>>"
		puts ""
		exit(0)
		when "c"
		credits
		when "p"
		party
		else
		puts "\t<< Please type again. >>"
		end
	end
end

def main_game_screen_message
	def_check("main_game_screen_message")
	puts """
	<< StarShip AI 2 >>
	
	  s - start game
	  q - quit game
	  c - credits	"""
	if $story_counter.amount == 5 then puts "\t  p - party_invitation" end
	puts ""
end


def main
	def_check("main")
	while true
		
		line
		status
		line
		prompt
		
		case $command
		when "q"
			main_game_screen
		when "?"
			help
		when "n"
			next_turn
		when "m"
			maintain
		when "c"
			credits
#Robots
		when "s", "send"
			robot_to_storage
		when "rf"
			robot_fix
		when "ru"
			robot_upgrade
		when "rr"
			robot_reset
		when "rs"
			robot_status
		when "ri"
			robots_info
		when "r?"
			help_robot
#Units
		when "uf"
			unit_fix
		when "us"
			unit_status
		when "ui"
			units_info
		when "u?"
			help_unit
		when "p?", "party?"
			party
#Teasters
		when "slu"
			state_limit_update
		when "dc"
			$check = !$check
		when "sr"
			state_report
		when "t?"
			help_program
		when "sb"	
			$air.amount += 300
			$shield.amount += 300
			$power.amount += 600		
		when "t1"
			$power.amount += $power_amount[:upgrade]
		when "t1"
			$event_order.each{|a| puts a.name}
		when "t3"

		else
			puts "\t<< Try to Type again. >>"
		end
	end
end


main_game_screen