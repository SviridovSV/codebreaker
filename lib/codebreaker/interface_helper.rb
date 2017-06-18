require 'codebreaker/game'
require 'codebreaker/interface'

module Ui
  def greeting
    puts "Welcome! Let's begin our game."
  end

  def proposal_and_input
    puts "Please, enter your code or 'h' for hint"
    user_answer = gets.chomp
    user_answer
  end

  def lucky_combination
    puts "Congratulations! You won!"
  end

  def save_result_proposition
    puts "Do you want to save your results? (Enter 'y' if yes, or any button if no)"
    answer = gets.chomp
    answer
  end

  def username
    puts "Enter your name"
    username = gets.chomp
    username
  end

  def new_game_proposition
    puts "Do You want to play again ? (Enter 'y' if yes, or any button if no)"
    answer = gets.chomp
    answer
  end

  def goodbye
    puts "See You later!!!"
  end

  def no_attempts
    puts "There are no attempts left"
  end
end