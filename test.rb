#module Test

    robots = {
        larry: "larry",
        moe: "moe",
        steve: "steve"
    }
    
    def test
    	puts "THIS IS A TEST FROM ROBORT.RB"
    end
    
    def pick_n_choose (dict)
        kept_dict = dict
        kept_dict.keep_if {|k,v| v.start_with?("m","l")}
    end
    
#end

print robots
print pick_n_choose(robots)

arry = [1,2,3]
arry[0] = 0