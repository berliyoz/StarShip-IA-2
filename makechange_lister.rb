File.foreach("main.rb").with_index do |line, line_num|
   puts "#{line_num+1}: #{line}" if line.include?("MAKECHANGE")
end
