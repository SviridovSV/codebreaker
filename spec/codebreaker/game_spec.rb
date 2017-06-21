require 'spec_helper'
require_relative 'codebreaker_data'

module Codebreaker

  RSpec.describe Game do

    subject(:game) { Game.new }

    context '#initialize' do
      it 'saves secret code' do
        expect(subject.instance_variable_defined?(:@secret_code)).to be true
      end

      it "sets secret code equal ''" do
        expect(subject.instance_variable_get(:@secret_code)).to eq('')
      end

      it 'saves hint' do
        expect(subject.instance_variable_defined?(:@hint)).to be true
      end

      it "sets hint equal true" do
        expect(subject.instance_variable_get(:@hint)).to be true
      end

      it 'sets available attempts equal ATTEMPTS NUMBER' do
        expect(subject.instance_variable_get(:@available_attempts)).to eq(10)
      end

      it "sets result equal ''" do
        expect(subject.instance_variable_get(:@result)).to eq('')
      end
    end

    context '#start' do

      before do
        subject.start
      end

      it 'create secret code' do
        expect(subject.instance_variable_get(:@secret_code)).not_to be_empty
      end

      it 'saves 4 numbers secret code' do
        expect(subject.instance_variable_get(:@secret_code).length).to eq(4)
      end

      it 'saves secret code with numbers from 1 to 6' do
        expect(subject.instance_variable_get(:@secret_code)).to match(/^[1-6]{4}$/)
      end
    end

    context '#check_input' do

      let(:not_valid_code) {'aaaaa'}
      let(:valid_code) {'1234'}
      let(:hint_code) {'h'}

      it 'throw the warning if user_code is not valid' do
        expect(subject.check_input(not_valid_code)).to eq 'Incorrect format'
      end

      it 'reduces available_attempts by 1' do
        subject.instance_variable_set(:@available_attempts, 10)
        allow(subject).to receive(:check_matches).with(valid_code).and_return('+')
        expect { subject.check_input(valid_code) }.to change { subject.available_attempts }.from(10).to(9)
      end

      it 'returns the result of matching' do
        allow(subject).to receive(:check_matches).with(valid_code).and_return('+')
        expect(subject.check_input(valid_code)).to eq '+'
      end
    end

    context '#hint_answer' do

      it 'returns one number from secret code' do
        subject.instance_variable_set(:@secret_code, '1234')
        expect(subject.hint_answer).to match(/^[1-4]{1}$/)
      end

      it 'change hint to false' do
        subject.hint_answer
        expect(subject.instance_variable_get(:@hint)).to be false
      end
    end

    context '#check_matches' do

      before do
        subject.start
      end

      CodebreakerData.data.each do |item|
        it "returns #{item[2]} when user code #{item[1]} and secret code  #{item[0]}" do
          subject.instance_variable_set(:@secret_code, item[0])
          subject.check_matches(item[1])
          expect(subject.instance_variable_get(:@result)).to eq item[2]
        end
      end
    end

    context '#save_to_file' do

      let(:filename) {"game_results.txt"}
      let(:username) {"Max"}

      before do
        subject.start
        subject.save_to_file(filename, username)
        allow(File).to receive(:open).with(filename,'a')
      end

      it 'creates file' do
        expect(File.exist?(filename)).to be true
      end

      it 'writes content to file' do
        subject.instance_variable_set(:@available_attempts, 8)
        stub_const('Game::ATTEMPT_NUMBER', 10)
        expect(File.read(filename)).to match "Max|used attempts 2"
      end
    end
  end
end