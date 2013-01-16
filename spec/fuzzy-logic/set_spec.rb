# encoding: utf-8

require_relative "spec_helper.rb"
require "minitest/autorun"

describe FuzzyLogic::Set do
  before do
    @valid_set = FuzzyLogic::Set.new(1) { |n|
      o = 0.0
      o = 1.0 if n >= 30
      o = 1.0 - (30.0 - n)/(30.0 - 20.0) if n < 30 and n >= 20
      o
    }

    @another_valid_set = FuzzyLogic::Set.new(1) { |n|
      n > 10 ? 0.0 : 1.0
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

    it "should have a height of 1" do
      @valid_set.height.must_equal 1
      @time_set.height.must_equal 1
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

  describe "should change height" do
    before do
      @temp_set = FuzzyLogic::Set.new(0) { |n|
        o = 0.0
        o = 1.0 if n > 10
        o
      }
    end

    it "should change the height from zero to one" do
      @temp_set.height.must_equal 0
      @temp_set.get(20)
      @temp_set.height.must_equal 1
    end
  end

  describe "if output/height of a set is out of range" do
    it "should raise an error on invlalid output" do
      lambda {
        FuzzyLogic::Set.new { |n|
          5
        }.get(1)
      }.must_raise TypeError
    end

    it "should raise an ArgumentError on invalid initial height" do
      lambda {
        FuzzyLogic::Set.new(2) { |n|
          true
        }
      }.must_raise ArgumentError

      lambda {
        FuzzyLogic::Set.new(:test) { |n|
          true
        }
      }.must_raise ArgumentError
    end
  end

  describe "fuzzy-set .support" do
    it "should give only on values above zero a true value, else false" do
      @valid_set.support(21).must_equal true
      @valid_set.support(20).must_equal false
    end

    it "should also deal with alphacut" do
      @valid_set.support(21, 0.5).must_equal false
      @valid_set.support(26, 0.5).must_equal true
    end
  end

  describe "fuzzy-set .core" do
    it "should give only on values equal to 1 a true value" do
      @valid_set.core(30).must_equal true
      @valid_set.core(29).must_equal false
    end

    it "shouldnt have a problem with an optional alphacut" do
      @valid_set.core(30, 0.5).must_equal true
      @valid_set.core(29, 0.5).must_equal false
    end
  end

  describe "add_helpers to every set" do
    it "should have a helper for and generator" do
      (0..40).to_a.each { |i|
        @valid_set.and(@another_valid_set).get(i).must_equal FuzzyLogic::Generate.and(@valid_set, @another_valid_set).get(i)
      }
    end
    it "should have a helper for or generator" do
      (0..40).to_a.each { |i|
        @valid_set.or(@another_valid_set).get(i).must_equal FuzzyLogic::Generate.or(@valid_set, @another_valid_set).get(i)
      }
    end
    it "should have a helper for not generator" do
      (0..40).to_a.each { |i|
        @valid_set.not.get(i).must_equal FuzzyLogic::Generate.not(@valid_set).get(i)
      }
    end
    it "can combined together" do
      test_set = FuzzyLogic::Generate.and(FuzzyLogic::Generate.not(@valid_set), FuzzyLogic::Generate.not(@another_valid_set))
      (0..40).to_a.each { |i|
        @valid_set.not.and(@another_valid_set.not).get(i).must_equal test_set.get(i)
      }
    end
  end
end
