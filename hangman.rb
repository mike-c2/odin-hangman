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

    self.class.print_instructions
  end

  def prepare_game_word
    word = self.class.select_word

    @secret_letters = word.split('').map do |letter|
      { letter: letter, visible: false }
    end
  end

  def play(letter)
    return unless letter_valid?(letter)

    letter = letter.upcase

    correct = @secret_letters.reduce(false) do |found, secret_letter|
      found || secret_letter[:visible] = letter == secret_letter[:letter]
    end

    @overall_letters_chosen += letter
    @wrong_letters_chosen += letter unless correct

    print_game

    puts 'Congratulations, you won the game!' if win?
    puts 'You lost the game' if lose?
  end

  def letter_valid?(letter)
    if win? || lose?
      puts 'The game is over, no more letters are allowed.'
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

  def self.print_instructions
    puts "\nWelcome to the Hangman game!\n\n"
    puts 'A random word is selected and masked. You will be given'
    puts "#{NUMBER_OF_CHANCES} chances to guess it. For each turn, enter a letter and"
    puts 'if correct, it will open up the letter on the board. If'
    puts 'wrong, the letter will be shown on the "Wrong Letters"'
    puts "list and the \"Wrong Answers Remaining\" will be deducted.\n\n"
    puts 'If you guess all of the correct letters in the word, you'
    puts 'will win.  If you exhaust all of your "Wrong Answers'
    puts "Remaining\" then you will lose.\n\n"
    puts "Now choose a letter, lower/uppercase does not matter.\n\n"
  end
end
