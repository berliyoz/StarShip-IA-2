def story_check
	def_check("stroy_check")
	puts "\t>> Jack: I would like to check what happend to the ship."
	puts "\t   Send me to maintain the Workshop, and I will do my best to find answers."
	$story_counter.amount += 1
end

def story_found
	def_check("story_found")
	puts "\t>> Jack: Good news I found something!"
	puts "\t   Gather everybody in HQ for briefing!"
	$story_counter.amount += 1
end

def story_party
	def_check("story_party")
	puts "\t>> Jack: Now that everybody are here!"
	STDIN.gets
	puts "\t>> Jack: I have some marvelus news!"
	STDIN.gets
	puts "\t>> Marvin: How can you open the BlackBox and get marvelus news?"
	STDIN.gets
	puts "\t>> Laneny: uncommon, but possible."
	STDIN.gets
	puts "\t>> Marvin: So what happened to the ship?"
	STDIN.gets
	puts "\t>> Jack: That I don't know."
	STDIN.gets
	puts "\t>> Dazh: What is the good news?"
	STDIN.gets
	puts "\t>> Jack: I found a party invention encrypted!!"
	STDIN.gets
	
	party_invitation
	STDIN.gets

	puts "\t>> Marvin: And?"
	STDIN.gets
	puts "\t>> Jack: I think we should go."
	STDIN.gets
	puts "\t>> Laneny: We can. The humans are in hibernation..."
	STDIN.gets
	puts "\t>> Jack: I think we should...."
	STDIN.gets
	puts "\t         Skip the rescue mission."
	STDIN.gets
	puts "\t         Go straight to the party."
	STDIN.gets
	puts "\t         Find some drinks along the way."
	STDIN.gets
	puts "\t>> Dazh: So.... Changing course to 35.4256° N, 111.2586° W ?"
	STDIN.gets
	puts "\t>> Marvin: I guess."
	STDIN.gets
	puts "\t>> Jack: A-48, What do you think?"
	puts "\t         should we just go to the party?"
	puts "\t         or should we wait to be rescued?"
	STDIN.gets
	
	while true
		puts ">> Should we change course to the party?"
		puts "   Yes" 
		puts "   No"
		puts ""
		print ">> "
		user_input = gets.chomp.downcase	
		case user_input
		
		when "y", "yes"
			puts "\t>> Jack: Marvelus!! Party! Party! Party!"
			puts """
				pppp     aa      rrrr    ttttttt   y   y  !!
				p   p   a  a     r   r      t       y y   !!
				pppp   aaaaaa    rrrr       t        y    !!
				p     a      a   r   r      t        y
				p    a        a  r    r     t        y    !!
			"""
			$story_counter.amount += 1
			main#_game_screen
		when "n", "no"
			puts "\t>> Jack: O.... Well.... I guess we can wait..."
			STDIN.gets
			puts "\t         You do know that this game is not real?"
			STDIN.gets
			puts "\t         But the party is. So finish the game and let's move."
			STDIN.gets
			puts "\t>> Laneny: If you would like to see the invition again,"
			puts "\t            Write in (p?) or (party?)"
			STDIN.gets
			$story_counter.amount += 1
			main#_game_screen
		else
			puts ">> Try to Type again."
		end
	end
	
end

def party_invitation
	puts" \t	**********************************************************"
	puts" \t	*                                                        *"
	puts "\t	*  YES YOU!!! MOVE YOUR ASS!! THE PARTY STARTS SOON!!!   *"
	puts "\t	*                                                        *"
	puts "\t	*  AND IF IT IS TOO LATE?!?!?                            *"
	puts "\t	*  USE YOUR TIME MACHINE DUMMY!!!                        *"
	puts "\t 	*                                                        *"
	puts "\t	*  DATE:  23/4/2033                                      *"
	puts "\t	*  PLACE: 35.4256° N, 111.2586° W                        *"
	puts "\t	*                                                        *"
	puts "\t	**********************************************************"		
end