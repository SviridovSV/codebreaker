module Codebreaker
  class Game

    ATTEMPT_NUMBER = 10

    attr_reader :available_attempts, :hint

    def initialize
      @hint = true
      @available_attempts = ATTEMPT_NUMBER
      @result = ""
      @secret_code = generate_code
    end

    def check_input(code)
      return 'Incorrect format' unless code_valid?(code)
      @available_attempts -= 1
      return check_matches(code)
    end

    def hint_answer
      @hint = false
      @secret_code.split('').sample
    end

    def check_matches(user_code)
      @result = ""
      return @result = '++++' if user_code == @secret_code
      sum_array = @secret_code.chars.zip(user_code.chars)
      exact_match_calculation(sum_array)
      just_match_calculation(sum_array)
      @result
    end

    def save_to_file(filename, username)
      File.open(filename, 'a') do |file|
        file.puts "#{username}|used attempts #{ATTEMPT_NUMBER - @available_attempts};"
      end
    end

    private

    def generate_code
      (1..4).map { rand(1..6) }.join
    end

    def exact_match_calculation(array)
      array.delete_if { |secret_item, user_item| @result << '+' if secret_item == user_item }
    end

    def just_match_calculation(array)
      rest_secret_code, rest_user_code = array.transpose
      rest_secret_code.each do |item|
        position = rest_user_code.index(item)
        next unless position
        @result << '-'
        rest_user_code.delete_at(position)
      end
    end

    def code_valid?(code)
      code.to_s.match(/^[1-6]{4}$/)
    end
  end
end