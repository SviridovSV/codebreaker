require 'codebreaker/game'
require 'codebreaker/interface'

module Ui
  def greeting
    puts "Welcome! Let's begin our game."
  end

  def proposal_and_input
    puts "Please, enter your code or 'h' for hint"
    gets.chomp
  end

  def lucky_combination
    puts "Congratulations! You won!"
  end

  def save_result_proposition
    puts "Do you want to save your results? (Enter 'y' if yes, or any button if no)"
    gets.chomp
  end

  def username
    puts "Enter your name"
    gets.chomp
  end

  def new_game_proposition
    puts "Do You want to play again ? (Enter 'y' if yes, or any button if no)"
    gets.chomp
  end

  def goodbye
    puts "See You later!!!"
  end

  def no_attempts
    puts "There are no attempts left"
  end

  def no_hint
    puts "There is no hint left"
    true
  end
end