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

  def self.select_word
    all_words = read_dictionary

    words = all_words.filter do |word|
      word.length.between?(MINIMUM_WORD_SIZE, MAXIMUM_WORD_SIZE)
    end

    return default_word if words.empty?

    words.sample
  end

  def display_secret_word
    @secret_letters.reduce('') do |word, letter|
      word += (letter[:visible] ? letter[:letter] : '_')
      "#{word} "
    end
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
    puts "Now choose a letter, lower/uppercase does not matter:\n\n"
  end
end
