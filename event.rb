=begin
TODO

2. Is there a difference between GOOD event and a BAD one?

=end

class Event
	attr_accessor :name, :code, :effects, :dazh_message
	
	def initialize(name, code, air = 0, shield = 0, power = 0, rescue_time = 0, dazh_message = nil)
		@name = name
		@code = code
		@dazh_message = dazh_message
		@effects = {
		air: air,
		shield: shield,
		power: power,
		rescue_time: rescue_time
		}
		
	end

	def report
			def_check("report")
		puts """
			--++ #{@name} ++--
		
		Code:________#{@code}
		Air:_________#{@effects[:air]}
		Shiels:______#{@effects[:shield]}
		Power:_______#{@effects[:power]}
		Rescue Time:_#{@effects[:rescue_time]}
		"""
	end
	
	def effect
			def_check("effect")
		$state[:air].amount += @effects[:air]
		$state[:shield].amount += @effects[:shield]
		$state[:power].amount += @effects[:power]
	end
end











