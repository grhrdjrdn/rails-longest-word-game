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
        @message = "Congratulations, #{@word} is a valid English word!"
        session[:score] = 0 if session[:score] == nil
        session[:score] += @word.size
      else
        @message = "Sorry, but #{@word} does not seem to be a valid English word!"
      end
    else
      @message = "Sorry, but #{@word} can’t be build out of #{@letters}."
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
