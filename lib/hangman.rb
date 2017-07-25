def start
  puts"-----------------------"
  puts"        HANGMAN"
  puts"-----------------------"
  puts"        INPUT"
  puts"\"load\"-loads last game"
  puts"\"save\"-saves game"
  puts"\"exit\"-exit w/out save"
  puts"Any singular letter is"
  puts"  treated as a guess"
end

def word_select
	words = File.readlines("5desk.txt")
	while true
		word = words[rand(words.length)].strip
		return word if word.length>4 && word.length<13
	end
end

def create_hidden_word word
	hidden_word=[]
	word.length.times {hidden_word << "*"}
	hidden_word
end

def get_input
	while true
		print "Input: "
		input = gets.chomp
		return input if input[/[a-zA-Z]+/] == input
		puts "Invalid Entry, Re-try"
	end
end


def play
	start
	word = word_select.downcase
	hidden_word = create_hidden_word word
	guesses_left = 6
	while true
		puts "-----------------------"
		played_letters||=[]
		puts "Hidden Word: " + hidden_word.join("")
		puts "#{guesses_left} guesses remaining"
		input = get_input.downcase

		if input.strip.length == 1
			if played_letters.include?(input) then puts "Letter already used!"
			else 
				played_letters << input
				puts "Played Letters: " + played_letters.join(", ")
				if word.include? input
					word.split("").each_with_index do |letter,index| 
						if letter == input 
						  hidden_word[index] = input
						end
					end
				else
					guesses_left -= 1
				end
				if word == hidden_word.join("")
					puts word
					puts "You got it!"
					exit
				end
				if guesses_left == 0 then exit end
			end
		else
			if input == "exit" then exit
			elsif input == "load" then puts "Loading"
			elsif input == "save" then puts "Saving"
			else puts "Unknown Command"
			end
		end
	end
end

play