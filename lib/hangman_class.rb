require 'yaml'

class Hangman
  attr_accessor :word, :hidden_word

  def initialize
    @word = word_select.downcase
    @hidden_word = generate_hidden_word(word)
    @guesses_left = 6
    @played_letters = []
    initial_display
  end

  def initial_display
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

  def generate_hidden_word word
    hidden_word=[]
    word.length.times {hidden_word << "*"}
    hidden_word
  end

  def display
    puts"-----------------------"
    puts "You have #{@guesses_left} guesses left"
    puts "Played Letters : " + @played_letters.sort.join(",") if !@played_letters[0].nil?
    puts "Hidden word: " + @hidden_word.join("")
  end

  def get_input
    while true
      print "Input: "
      input = gets.chomp
      return input if input[/[a-zA-Z]+/] == input
      puts "Invalid Entry, Re-try"
    end
  end

  def input_handler input
    if input.strip.length != 1
      word_commands input
    else
      if @played_letters.include?(input)
        puts "Letter already used!"
      else
        @played_letters << input
        if @word.include? input
          word.split("").each_with_index do |letter,index|
            @hidden_word[index] = input if letter == input
          end
        else
          @guesses_left -= 1
        end
      end
    end

  end

  def word_commands input
    case input
    when "save"
      File.open("saved_game.yaml","w").write(Psych.dump(self))
      puts "Saved!"
    when "load"
      puts "Loading!"
      begin
        save = Psych.load(File.open("saved_game.yaml"))
        save.play
      rescue
        puts "No saved game!"
      end
    when "exit"
      puts "Good bye!"
      exit
    else
      puts "Invalid Entry!"
    end
  end

  def check_end_conditions
    if @word == @hidden_word.join("")
      puts "You got it!"
      puts  "The word was #{@word}!"
      exit
    end
    if @guesses_left == 0
      puts "Out of guesses!"
      puts "The word was #{@word}!"
      exit
    end
  end

  def play
    while true
      display
      @input = get_input.downcase
      input_handler @input
      check_end_conditions
    end
  end
end

my_game = Hangman.new
my_game.play