module Codebreaker
  class Game

    ATTEMPT_NUMBER = 10

    def initialize
      @secret_code = ""
      @hint = 1
    end

    def start
      @secret_code = (1..4).map { rand(1..6) }.join
    end

    def compare(code)
    end
  end
end