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
      while @game.available_attempts > 0
        guess = proposal_and_input
        next if hint_call?(guess)
        rez = @game.check_input(guess)
        puts rez
        break if win?(rez)
      end
      no_attempts unless @game.available_attempts > 0
      save_result
    end

    private

    def save_result
      user_answer = save_result_proposition
      return new_game unless user_agree?(user_answer)
      @game.save_to_file("game_results.txt", username)
    end

    def new_game
      user_answer = new_game_proposition
      return goodbye unless user_agree?(user_answer)
      @game = Game.new
      game_begin
    end

    def hint_input?(code)
      code.to_s.match(/^h$/)
    end

    def hint_call?(code)
      return false unless hint_input?(code)
      no_hint unless @game.hint
      puts @game.hint_answer
      true
    end

    def win?(combination)
      return false unless combination == '++++'
      lucky_combination
      true
    end

    def user_agree?(answer)
      answer == 'y'
    end
  end
end
