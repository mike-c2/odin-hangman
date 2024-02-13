# frozen_string_literal: true

##
# This class will be used to play the Hangman game
class Hangman
  DICTIONARY_FILE = 'google-10000-english-no-swears.txt'
  MINIMUM_WORD_SIZE = 5
  MAXIMUM_WORD_SIZE = 12
  NUMBER_OF_CHANCES = 7

  def initialize
    @overall_letters_chosen = ''
    @wrong_letters_chosen = ''
  end

  def prepare_game_word
    word = self.class.select_word

    @secret_letters = word.split('').map do |letter|
      { letter: letter, visible: false }
    end
  end

  def self.select_word
    return nil unless File.exist?(DICTIONARY_FILE) && File.readable?(DICTIONARY_FILE)

    all_words = File.readlines(DICTIONARY_FILE).map do |word|
      word.chomp.upcase
    end

    words = all_words.filter do |word|
      word.length.between?(MINIMUM_WORD_SIZE, MAXIMUM_WORD_SIZE)
    end

    words.sample
  end
end
