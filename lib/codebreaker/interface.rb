require "codebreaker/game"

module Codebreaker
  class Interface

    def initialize
      @game = Game.new
    end

    def game_begin
      puts "Welcome! Let's begin our game."
      @game.start
      while @game.available_attempts > 0
        puts "Please, enter your code or 'h' for hint"
        user_answer = gets.chomp
        game_return = @game.check_enter(user_answer)
        puts game_return
        if game_return == "++++"
          puts "Congratulations! You won!"
          break
        end
      end
      save_result
    end

    private

    def new_game
      puts "Do You want to play again ? (Enter 'y' if yes, or any button if no)"
      answer = gets.chomp
      if answer == 'y'
        @game = Game.new
        game_begin
      else
        puts "See You later!!!"
      end
    end

    def save_result
      puts "Do you want to save your results? (Enter 'y' if yes, or any button if no)"
      answer = gets.chomp
      if answer == 'y'
        puts "Enter your name"
        username = gets.chomp
        @game.save_to_file("game_results.txt", username)
        new_game
      end
    end
  end
end
