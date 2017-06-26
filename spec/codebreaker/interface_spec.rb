require 'spec_helper'

module Codebreaker
  RSpec.describe Interface do

    subject(:interface) { Interface.new }

    let(:game) { subject.instance_variable_get(:@game) }

    context '#initialize' do
      it "creates object like Game class" do
        expect(subject.instance_variable_get(:@game).instance_of?(Game)).to be true
      end

      it "shows greeting message" do
        expect { subject }.to output(/Welcome! Let's begin our game./).to_stdout
      end
    end

    context '#game_begin' do

      let(:ask_hint) { 'h' }
      let(:ask_code) { '1234' }

      it 'calls start from game-object' do
        allow(game).to receive(:available_attempts).and_return(0)
        allow(subject).to receive(:save_result)
        subject.game_begin
      end

      it 'calls check_input from game-object 10 times' do
        allow(subject).to receive(:save_result)
        allow(game).to receive(:@secret_code).and_return('5566')
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

      it 'check input and return true if user asks hint' do
        expect(subject.send(:hint_call?, ask_hint)).to eq true
      end

      it 'check input and return false if user does not ask hint' do
        expect(subject.send(:hint_call?, ask_code)).to eq false
      end

      it 'checks input and returns no hint if user asks hint twice' do
        allow(game).to receive(:hint).and_return(false)
        expect(subject).to receive(:no_hint).and_return(true)
        subject.send(:hint_call?, ask_hint)
      end
    end

    context '#save_result' do

      it 'calls save_to_file from game-object if user agreed' do
        allow(subject).to receive(:save_result_proposition).and_return('y')
        allow(subject).to receive(:username).and_return('Alex')
        allow(subject).to receive(:new_game).and_return("See you later!")
        expect(game).to receive(:save_to_file).once
        subject.send(:save_result)
      end

      it "doesn't call save_to_file if user rejected" do
        allow(subject).to receive(:save_result_proposition).and_return('n')
        allow(subject).to receive(:new_game).and_return("See you later!")
        expect(game).not_to receive(:save_to_file)
        subject.send(:save_result)
      end

      it 'starts new game if user agreed' do
        allow(subject).to receive(:save_result_proposition).and_return('n')
        allow(subject).to receive(:new_game_proposition).and_return('y')
        expect(subject).to receive(:game_begin)
        subject.send(:save_result)
      end

      it 'finishes the game if user rejected' do
        allow(subject).to receive(:save_result_proposition).and_return('n')
        allow(subject).to receive(:new_game_proposition).and_return('n')
        expect(subject).to receive(:goodbye).and_return("See you later!")
        subject.send(:save_result)
      end
    end
  end
end