# frozen_string_literal: true

##
# This class will be used to play the Hangman game
class Hangman
  DICTIONARY_FILE = 'google-10000-english-no-swears.txt'
  MINIMUM_WORD_SIZE = 5
  MAXIMUM_WORD_SIZE = 12
  NUMBER_OF_CHANCES = 7

  def initialize
    restart
  end

  def restart
    @overall_letters_chosen = ''
    @wrong_letters_chosen = ''

    prepare_game_word
  end

  def prepare_game_word
    @secret_word = self.class.select_word

    @secret_letters = @secret_word.split('').map do |letter|
      { letter: letter, visible: false }
    end
  end

  def play(letter)
    return unless letter_valid?(letter)

    letter = letter.upcase
    process_play(letter)

    @overall_letters_chosen += letter

    print_game

    puts 'Congratulations, you won the game!' if win?
    puts "You lost the game, the correct word was: #{@secret_word}" if lose?
  end

  def process_play(letter)
    correct = false

    @secret_letters.map! do |secret_letter|
      unless secret_letter[:visible]
        secret_letter[:visible] = letter == secret_letter[:letter]
        correct ||= secret_letter[:visible]
      end

      secret_letter
    end

    @wrong_letters_chosen += letter unless correct
  end

  def letter_valid?(letter)
    if win? || lose?
      puts 'The game is over, no more letters are allowed.  Restart the game to play again.'
      return false
    end

    unless letter.is_a?(String) && letter.match(/^[a-zA-Z]$/)
      puts 'What you entered is not valid, try again'
      return false
    end

    !duplicate_letter?(letter)
  end

  def duplicate_letter?(letter)
    letter = letter.upcase

    if @overall_letters_chosen.include?(letter)
      puts "The #{letter} has already been called.\n\n"
      return true
    end

    false
  end

  def win?
    @secret_letters.all? { |letter| letter[:visible] }
  end

  def lose?
    @wrong_letters_chosen.length >= NUMBER_OF_CHANCES
  end

  def print_game
    puts "Wrong Answers Remaining: #{NUMBER_OF_CHANCES - @wrong_letters_chosen.length}\n\n"
    puts "Wrong letters selected during this game: #{@wrong_letters_chosen.split('').join(' ')}\n\n"
    puts "Guess this word:  #{display_secret_word}\n\n"
  end

  def display_secret_word
    @secret_letters.reduce('') do |word, letter|
      word += (letter[:visible] ? letter[:letter] : '_')
      "#{word} "
    end
  end

  def self.select_word
    all_words = read_dictionary

    words = all_words.filter do |word|
      word.length.between?(MINIMUM_WORD_SIZE, MAXIMUM_WORD_SIZE)
    end

    return default_word if words.empty?

    words.sample
  end

  def self.read_dictionary
    return default_word unless File.exist?(DICTIONARY_FILE) && File.readable?(DICTIONARY_FILE)

    begin
      words = File.readlines(DICTIONARY_FILE).map do |word|
        word.chomp.upcase
      end
    rescue Errno
      return default_word
    end

    words
  end

  def self.default_word
    puts "\nA problem occurred with reading the dictionary file:\n\n"
    puts "  #{DICTIONARY_FILE}\n\n"
    puts "Using default word, but you will want to fix that.\n\n"

    ['JAZZED']
  end
end

##
# This class will manage the game and
# the player options.
class GameManager
  def initialize
    @hangman = Hangman.new

    self.class.print_options
    self.class.print_instructions
    @hangman.print_game
  end

  def play_game
    loop do
      play_input = gets.chomp.upcase

      case play_input
      when 'HELP'
        self.class.print_options
      when 'PRINT'
        @hangman.print_game
      when 'QUIT'
        break
      when 'RESTART'
        @hangman.restart
        self.class.print_instructions
        @hangman.print_game
      when 'SAVE'
        puts 'Save has not been implemented yet.'
      when 'LOAD'
        puts 'Load has not been implemented yet.'
      else
        @hangman.play(play_input)
      end
    end
  end

  def self.print_options
    puts "\nDuring the game, you will have these options:\n\n"
    puts '  Help: Print out these options again.'
    puts '  Print:  Prints out the game board.'
    puts '  Quit: Leave the game.'
    puts '  Restart:  Start the game over.'
    puts '  Save:  Save the game to file.'
    puts "  Load:  Load a game that was previously saved and continue playing that.\n\n"
    puts "These words can be typed at anytime and they are case insensitive.\n\n"
  end

  def self.print_instructions
    puts "\nWelcome to the Hangman game!\n\n"
    puts 'A random word is selected and masked. You will be given'
    puts "#{Hangman::NUMBER_OF_CHANCES} chances to guess it. For each turn, enter a letter and"
    puts 'if correct, it will open up the letter on the board. If'
    puts 'wrong, the letter will be shown on the "Wrong Letters"'
    puts "list and the \"Wrong Answers Remaining\" will be deducted.\n\n"
    puts 'If you guess all of the correct letters in the word, you'
    puts 'will win.  If you exhaust all of your "Wrong Answers'
    puts "Remaining\" then you will lose.\n\n"
    puts "Now choose a letter, lower/uppercase does not matter.\n\n"
  end
end

game = GameManager.new
game.play_game
