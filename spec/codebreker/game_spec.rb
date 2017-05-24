require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
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

      it "sets hint equal 1" do
        expect(subject.instance_variable_get(:@hint)).to eq(1)
      end
    end
    context '#start' do
      let(:game) { Game.new }

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
        expect(subject.instance_variable_get(:@secret_code)).to match(/[1-6]+/)
      end
    end
  end
end