module Codebreaker
  class Game

    ATTEMPT_NUMBER = 10

    attr_reader :available_attempts

    def initialize
      @secret_code = ""
      @hint = true
      @available_attempts = ATTEMPT_NUMBER
    end

    def start
      @secret_code = (1..4).map { rand(1..6) }.join
    end

    def check(code)
      return 'There are no attempts left' if @available_attempts.zero?
      return 'Incorrect format' unless code_valid?(code)||code.to_s.match(/^h$/)
      @available_attempts -= 1
      return hint if code.to_s.match(/^h$/)
    end

    def hint
      @hint = false
      @secret_code.split('').sample
    end

    private

    def code_valid?(code)
      code.to_s.size == 4 && code.to_s.match(/^[1-6]{4}$/)
    end
  end
end