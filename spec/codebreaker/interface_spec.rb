require 'spec_helper'

module Codebreaker
  RSpec.describe Interface do

    let(:interface) { Interface.new }

    context '#initialize' do
      it "creates object like Game class" do
        expect(subject.instance_variable_get(:@game).instance_of?(Game)).to be true
      end

      it "shows greeting massege" do
        expect { subject }.to output(/Welcome! Let's begin our game./).to_stdout
      end
    end

    context '#game_begin' do
      let(:game) { subject.instance_variable_get(:@game) }

      it 'calls start from game-object' do
        allow(game).to receive(:available_attempts).and_return(0)
        allow(subject).to receive(:save_result)
        expect(game).to receive(:start)
        subject.game_begin
      end

      it 'calls check_input from game-object 10 times' do
        allow(subject).to receive(:save_result)
        allow(subject).to receive_message_chain(:gets, :chomp).and_return('1234')
        expect(game).to receive(:check_input).and_call_original.exactly(10).times
        subject.game_begin
      end

      it 'shows congratulation if user won' do
        allow(subject).to receive(:save_result)
        allow(subject).to receive_message_chain(:gets, :chomp)
        allow(game).to receive(:check_input).and_return('++++')
        expect { subject.game_begin }.to output(/Congratulations! You won!/).to_stdout
        subject.game_begin
      end

      it 'shows warning if no attemts left' do
        allow(game).to receive(:available_attempts).and_return(0)
        allow(subject).to receive(:save_result)
        expect { subject.game_begin }.to output(/There are no attempts left/).to_stdout
        subject.game_begin
      end
    end
  end
end