require "codebreaker/game"
require 'codebreaker/interface_helper'

module Codebreaker
  class Interface
    include Ui

    def initialize
      @game = Game.new
      greeting
    end

    def game_begin
      @game.start
      while @game.available_attempts > 0
        guess = proposal_and_input
        rez = @game.check_input(guess)
        if rez == '++++'
          lucky_combination
          break
        end
      end
      no_attempts unless @game.available_attempts > 0
      save_result
    end

    private

    def save_result
      user_answer = save_result_proposition
      if user_answer == 'y'
        user_name = username
        @game.save_to_file("game_results.txt", user_name)
      end
      new_game
    end

    def new_game
      user_answer = new_game_proposition
      if user_answer == 'y'
        @game = Game.new
        game_begin
      else
        goodbye
      end
    end
  end
end
