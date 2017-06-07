module Codebreaker
  class Game

    ATTEMPT_NUMBER = 10

    attr_reader :available_attempts

    def initialize
      @secret_code = ""
      @hint = true
      @available_attempts = ATTEMPT_NUMBER
      @result = ""
    end

    def start
      @secret_code = (1..4).map { rand(1..6) }.join
    end

    def check_enter(code)
      return 'There are no attempts left' if @available_attempts.zero?
      return 'Incorrect format' unless code_valid?(code)||code.to_s.match(/^h$/)
      @available_attempts -= 1
      return hint if code.to_s.match(/^h$/)
      return check_matches(code)
    end

    def hint
      return 'No hints left' unless @hint
      @hint = false
      @secret_code.split('').sample
    end

    def check_matches(user_code)
      @result = ""
      return @result = '++++' if user_code == @secret_code
      sum_array = @secret_code.chars.zip(user_code.chars)
      sum_array.delete_if { |secret_item, user_item| @result << '+' if secret_item == user_item }
      sum_array.transpose[0].each { |item| @result << '-' if sum_array.transpose[1].include?(item) }
      @result
    end

    private

    def code_valid?(code)
      code.to_s.size == 4 && code.to_s.match(/^[1-6]{4}$/)
    end
  end
end