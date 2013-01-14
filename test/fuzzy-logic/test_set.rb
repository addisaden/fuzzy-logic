# encoding: utf-8

require_relative "load_fuzzy_logic.rb"
require "minitest/autorun"

describe FuzzyLogic::Set do
  before do
    @valid_set = FuzzyLogic::Set.new(1) { |n|
      o = 0.0
      o = 1.0 if n >= 30
      o = 1.0 - (30.0 - n)/(30.0 - 20.0) if n < 30 and n >= 20
      o
    }

    @invalid_set = FuzzyLogic::Set.new(1) { |n|
      "i am invalid."
    }

    # Is christmas near?
    @time_set = FuzzyLogic::Set.new(1) { |n|
      t = Time.now
      o = 0.0
      if n.month == 12 and n.day <= 24 then
        o = 1.0 if n.day >= 20
        o = 1.0 - (24.0 - n.day)/(24.0 - 6.0) if n.day >= 6.0 and n.day < 20.0
      end
      o
    }
  end

  describe "when get values from a valid set" do
    it "should have a respond with 1" do
      @valid_set.get(30.0).must_equal 1.0
      @time_set.get(Time.new(2013,12,24)).must_equal 1.0
      @time_set.get(Time.new(2013,12,20)).must_equal 1.0
    end

    it "should have a respond with 0" do
      @valid_set.get(20).must_equal 0
      @time_set.get(Time.new(2013,11)).must_equal 0
      @time_set.get(Time.new(2013,12,6)).must_equal 0
    end

    it "should have a respond near 0" do
      [@valid_set.get(21), @time_set.get(Time.new(2013,12,7))].each { |t|
        t.must_be :!=, 0
        t.must_be :<, 0.3
      }
    end

    it "should have a respond near 1" do
      [@valid_set.get(29), @time_set.get(Time.new(2013,12,19))].each { |t|
        t.must_be :!=, 1
        t.must_be :>, 0.7
      }
    end
  end

  describe "when give wrong arguments" do
    it "should raise an ArgumentError" do
      lambda { @valid_set.get(Object.new) }.must_raise ArgumentError
      lambda { @valid_set.get(2, Object.new) }.must_raise ArgumentError
    end

    it "should raise an TypeError" do
      lambda { @invalid_set.get(3) }.must_raise TypeError
    end
  end
end
