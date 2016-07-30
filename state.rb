class State
	attr_accessor :name, :amount, :limit
	
	def initialize(name, amount, limit)
		@name = name
		@amount = amount
		@limit = limit
	end
	
	def update(new_limit)
		@limit = new_limit
	end
		
end	