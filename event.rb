=begin
TODO

2. Is there a difference between GOOD event and a BAD one?

=end

class Event
	attr_accessor :name, :code, :effects
	
	def initialize(name, code, air = 0, shield = 0, power = 0, rescue_time = 0)
		@name = name
		@code = code
		@effects = {
		air: air,
		shield: shield,
		power: power,
		rescue_time: rescue_time
		
		}
	end

	def effect
		$state[:air].amount += @effects[:air]
		$state[:shield].amount += @effects[:shield]
		$state[:power].amount += @effects[:power]
	end
end










