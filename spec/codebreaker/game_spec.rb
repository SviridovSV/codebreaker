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

      it "sets result equal ''" do
        expect(subject.instance_variable_get(:@result)).to eq('')
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

    context '#check_enter' do

      let(:not_valid_code) {'aaaaa'}
      let(:valid_code) {'1234'}
      let(:hint_code) {'h'}

      it 'throw the warning if user_code is not valid' do
        expect(subject.check_enter(not_valid_code)).to eq 'Incorrect format'
      end

      it 'throw the warning if there are no attempts left' do
        subject.instance_variable_set(:@available_attempts, 0)
        expect(subject.check_enter(valid_code)).to eq 'There are no attempts left'
      end

      it 'reduces available_attempts by 1' do
        subject.instance_variable_set(:@available_attempts, 10)
        allow(subject).to receive(:check_matches).with(valid_code).and_return('+')
        expect { subject.check_enter(valid_code) }.to change { subject.available_attempts }.from(10).to(9)
      end

      it 'returns hint if user entered h' do
        allow(subject).to receive(:hint).and_return('2')
        expect(subject.check_enter(hint_code)).to eq('2')
      end

      it 'returns the result of matching' do
        allow(subject).to receive(:check_matches).with(valid_code).and_return('+')
        expect(subject.check_enter(valid_code)).to eq '+'
      end
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

      it 'returns no hint if hint was asked once more' do
        subject.instance_variable_set(:@hint, false)
        expect(subject.hint).to eq 'No hints left'
      end
    end

    context '#check_matches' do

      before do
        subject.start
      end

      sample_data = [
        ['1111', '2222', ''],
        ['1211', '3333', ''],
        ['1121', '3333', ''],
        ['1112', '3333', ''],
        ['1112', '4444', ''],
        ['1212', '3456', ''],
        ['3334', '3331', '+++'],
        ['3433', '3133', '+++'],
        ['3343', '3313', '+++'],
        ['4333', '1333', '+++'],
        ['4332', '1332', '+++'],
        ['4323', '1323', '+++'],
        ['4233', '1233', '+++'],
        ['2345', '2346', '+++'],
        ['2534', '2634', '+++'],
        ['2354', '2364', '+++'],
        ['1234', '5123', '---'],
        ['3612', '1523', '---'],
        ['3612', '2531', '---'],
        ['1234', '5612', '--'],
        ['1234', '5621', '--'],
        ['4321', '1234', '----'],
        ['3421', '1234', '----'],
        ['3412', '1234', '----'],
        ['4312', '1234', '----'],
        ['1423', '1234', '+---'],
        ['1342', '1234', '+---'],
        ['5255', '2555', '++--'],
        ['5525', '2555', '++--'],
        ['5552', '2555', '++--'],
        ['6262', '2626', '----'],
        ['6622', '2626', '++--'],
        ['2266', '2626', '++--'],
        ['2662', '2626', '++--'],
        ['6226', '2626', '++--'],
        ['3135', '3315', '++--'],
        ['3513', '3315', '++--'],
        ['3351', '3315', '++--'],
        ['1353', '3315', '+---'],
        ['5313', '3315', '++--'],
        ['1533', '3315', '----'],
        ['5331', '3315', '+---'],
        ['5133', '3315', '----'],
        ['3361', '3315', '++-'],
        ['3136', '3635', '++-'],
        ['1336', '6334', '++-'],
        ['1363', '6323', '++-'],
        ['1633', '6233', '++-'],
        ['1234', '4343', '--']
      ];

      sample_data.each do |item|
        it "returns #{item[2]} when user code #{item[1]} and secret code  #{item[0]}" do
          subject.instance_variable_set(:@secret_code, item[0])
          subject.check_matches(item[1])
          expect(subject.instance_variable_get(:@result)).to eq item[2]
        end
      end
    end
  end
end