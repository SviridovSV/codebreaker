require "codebreaker/game"

module Codebreaker
  class Interface

    def initialize
      @game = Game.new
    end

    def game_begining
      puts "Wellcome!"
      puts "Let's begin our game."
      @game.start
    end
  end
end
