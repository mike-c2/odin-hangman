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
