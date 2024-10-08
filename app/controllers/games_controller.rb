require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    alphabet = ("A".."Z").to_a
    @letters = []
    10.times do |index|
      @letters[index] = alphabet.sample
    end
    @letters_string = @letters.join
  end

  def score
    # raise
    @params = params
    @letters = params[:letters]
    @word = params[:word].upcase
    @message = "Test Message"

    @included = included?(@word, @letters)

    if included?(@word, @letters)
      if english_word?(@word)
        @message = "well done"
      else
        @message = "not an english word"
      end
    else
      @message = "not in the grid";
    end


  end



  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = URI.parse("https://dictionary.lewagon.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

end
