require 'spec_helper'

module Codebreaker
  RSpec.describe Interface do

    let(:interface) { Interface.new }

    context '#initialize' do
      it "creates object like Game class" do
        expect(subject.instance_variable_get(:@game).instance_of?(Game)).to be true
      end
    end

    context '#game_begin' do
      let(:game) { subject.instance_variable_get(:@game) }

      it 'shows welcome message' do
        allow(game).to receive(:start)
        allow(game).to receive(:available_attempts).and_return(0)
        allow(subject).to receive(:save_result)
        expect { subject.game_begin }.to output(/Welcome! Let's begin our game./).to_stdout
      end

      it 'calls start from game-object' do
        allow(game).to receive(:available_attempts).and_return(0)
        allow(subject).to receive(:save_result)
        expect(game).to receive(:start)
        subject.game_begin
      end

      it 'calls check_enter from game-object 10 times' do
        allow(subject).to receive(:save_result)
        allow(subject).to receive_message_chain(:gets, :chomp).and_return('1234')
        expect(game).to receive(:check_enter).and_call_original.exactly(10).times
        subject.game_begin
      end

      it 'shows congratulation if user won' do
        allow(subject).to receive(:save_result)
        allow(subject).to receive_message_chain(:gets, :chomp)
        allow(game).to receive(:check_enter).and_return('++++')
        expect { subject.game_begin }.to output(/Congratulations! You won!/).to_stdout
        subject.game_begin
      end

      it 'asks to save results if user won' do
        allow(subject).to receive_message_chain(:gets, :chomp)
        allow(game).to receive(:check_enter).and_return('++++')
        expect { subject.send(:save_result) }.to output(/Do you want to save your results? (Enter 'y' if yes, or any button if no)/).to_stdout

      end
    end
  end
end