# encoding: utf-8

require_relative "spec_helper.rb"
require "minitest/autorun"

describe FuzzyLogic::Collection do
  before do
    @collection = FuzzyLogic::Collection.new("Collection Test") { |t|
      o = true
      if not t.is_a? Numeric then
        o = false
      elsif t < 0 or t > 100 then
        o = false
      end
      o
    }

    @empty_collection = FuzzyLogic::Collection.new("Empty-Collection Test") { |t|
      true
    }

    @wrong_test_collection = FuzzyLogic::Collection.new("Wrong-Proc-Test in Collection Test") { |n|
      42
    }
  end

  describe "can add a fuzzyset" do
    it "should work like a normal hash" do
      @collection[:test] = FuzzyLogic::Generate.trapezoid(10,20,30,40)
    end

    it "should throw an error when get not FuzzySet" do
      lambda { @collection[:no_fuzzy_set] = 13 }.must_raise ArgumentError
    end
  end

  describe "give a hash on a value" do
    before do
      @collection[:test] = FuzzyLogic::Generate.trapezoid(10,20,30,40)
    end

    it "wont be empty on 25 (or 0 with true)" do
      @collection.get(25).wont_be_empty
      @collection.get(0, true).wont_be_empty
    end
    
    it "should return a fuzzy-set on hash-indexing or nil if its not presence" do
      @collection[:test].must_be :is_a?, FuzzyLogic::Set
      @collection[:i_am_an_invalid_key].must_be_nil
    end

    it "should be empty on 0" do
      @collection.get(0).must_be_empty
    end

    it "should raise an error with wrong arguments" do
      lambda { @collection.get("Hallo") }.must_raise ArgumentError
      lambda { @collection.get(-1) }.must_raise ArgumentError
      lambda { @collection.get(100.01) }.must_raise ArgumentError
    end

    it "should have a .length of one" do
      @collection.length.must_equal 1
    end
  end

  describe "an empty collection" do
    it "should give an empty Hash on .get" do
      @empty_collection.get(1).must_be :is_a?, Hash
      @empty_collection.get(1).must_be_empty
    end

    it "should give a .length of zero" do
      @empty_collection.length.must_equal 0
    end
  end

  describe "a collection with a wrong test" do
    it "should give a TypeError on get" do
      lambda { @wrong_test_collection.get(1) }.must_raise TypeError
    end
  end
end
