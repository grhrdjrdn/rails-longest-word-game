require 'open-uri'
require 'json'

require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert test: "New game"
    assert_selector "li", count: 10
  end

  test "Fill the form with a random word, and get a message that the word is not in the grid" do
    visit new_url
    fill_in 'word', with: 'XXXXXX'
    click_button
    assert_text "can’t be build"
  end

  test "Fill the form with a valid English word and get a “Congratulations” message" do
    visit new_url
    testword = ""
    letters = all('li').map(&:text)
    words = letters.combination(3).to_a.shuffle
    counter = 0
    words.each do |word|
      testword = word.join
      puts "Testing if #{testword} is an English word"
      counter += 1
      testword = "XXX" if counter > 10
      break if english_word?(testword) || counter > 10
    end
    puts "Using #{testword} for the test"
    fill_in 'word', with: testword
    click_button
    assert_text "Congratulations"
  end

end

def english_word?(word)
  response = URI.parse("https://dictionary.lewagon.com/#{word}")
  json = JSON.parse(response.read)
  return json['found']
end
