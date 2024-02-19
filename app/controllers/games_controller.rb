require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array('A'..'Z').sample(10)
  end

  def score
    @word = params[:word] ? params[:word].upcase : ""
    @grid = params[:original_grid] ? params[:original_grid].upcase : ""
    url = "https://wagon-dictionary.herokuapp.com/#{CGI.escape(@word.downcase)}"
    user_serialized = URI.open(url).read
    result = JSON.parse(user_serialized)

    if result['found']
      if in_grid?(@word, @grid)
        @result = 'valid_word'
      else
        @result = 'invalid_word'
      end
    else
      @result = 'inexistent_word'
    end
  end

  private

  def in_grid?(word, grid)
    puts "Word: #{word}"  # Add these lines
    puts "Grid: #{grid}"

    grid_copy = grid.dup
    word.chars.all? do |letter|
      puts "Checking letter: #{letter}"
      puts "Grid Copy: #{grid_copy}"
      if grid_copy.include?(letter)
        grid_copy.sub!(letter, '')
        true
      else
        false
      end
    end
  end


end
