require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    # TODO: generate random grid of letters
    @letters = []
    arr_of_letters = ("A".."Z").to_a.shuffle
    10.times { @letters << arr_of_letters[rand(1..24)] }
    @letters
  end

  def score
    @attempt = params[:score]
    run_game(@attempt, params[:letters])
  end

  def word_checker(word)
    url = "https://dictionary.lewagon.com/"
    worb = URI.open(url + word).read
    JSON.parse(worb)
  end

  def run_game(attempt, grid)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    data = word_checker(attempt)
    valid = data["found"]
    length = data["length"]
    attempt.upcase!
    end_game_message(attempt, valid, grid, length)
  end

  def end_game_message(attempt, valid, grid, length)
    in_the_grid = attempt.upcase.chars.all? { |c| grid.include?(c) }
    letters_overused = []
    attempt.chars.each { |i| letters_overused.push(attempt.count(i) > grid.count(i)) }
    end_game_calculations(in_the_grid, letters_overused, length, valid)
  end

  def end_game_calculations(in_the_grid, letters_overused, length, valid)
    score = 0
    if !in_the_grid || letters_overused.include?(true)
      @message = "That word is not in the grid."
    elsif !valid
      @message = "That word is not an english word."
    else
      @message = "Well done"
      @score = length
    end
    @results = { score: score, message: @message }
  end
end
