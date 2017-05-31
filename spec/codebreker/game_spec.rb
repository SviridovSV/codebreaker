require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
    let(:game) { Game.new }

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
    end

    context '#start' do

      before do
        subject.start
      end

      it 'saves secret code' do
        expect(subject.instance_variable_get(:@secret_code)).not_to be_empty
      end

      it 'saves 4 numbers secret code' do
        expect(subject.instance_variable_get(:@secret_code).length).to eq(4)
      end

      it 'saves secret code with numbers from 1 to 6' do
        expect(subject.instance_variable_get(:@secret_code)).to match(/^[1-6]{4}$/)
      end
    end

    context '#check' do

      let(:not_valid_code) {'aaaaa'}
      let(:valid_code) {'1234'}
      let(:hint_code) {'h'}

      it 'throw the warning if user_code is not valid' do
        expect(subject.check(not_valid_code)).to eq 'Incorrect format'
      end

      it 'throw the warning if there are no attempts left' do
        subject.instance_variable_set(:@available_attempts, 0)
        expect(subject.check(valid_code)).to eq 'There are no attempts left'
      end

      it 'reduces available_attempts by 1' do
        subject.instance_variable_set(:@available_attempts, 10)
        expect { subject.check(valid_code) }.to change { subject.available_attempts }.from(10).to(9)
      end

      it 'returns hint if user entered h' do
        allow(subject).to receive(:hint).and_return('2')
        expect(subject.check(hint_code)).to eq('2')
      end

      it 'returns the result of matching'
    end

    context '#hint' do

      it 'returns one number from secret code' do
        subject.instance_variable_set(:@secret_code, '1234')
        expect(subject.hint).to match(/^[1-4]{1}$/)
      end

      it 'change hint to false' do
        subject.hint
        expect(subject.instance_variable_get(:@hint)).to be false
      end
    end

    context '#match' do
      it 'returns plus if one number matches exactly'
      it 'returns minus if one number matches'
      it 'returns no_matches if nothing matches'

    end
  end
end