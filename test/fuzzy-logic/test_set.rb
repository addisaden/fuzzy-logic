# encoding: utf-8

require_relative "load_fuzzy_logic.rb"
require 'test/unit'

class TestFuzzyLogicSet < Test::Unit::TestCase
  def setup
    @a_set = FuzzyLogic::Set.new(1) { |n|
      o = 0.0
      o = 1.0 if n >= 30
      o = 1 - (30.0 - n)/(30.0 - 20.0) if n >= 20 and n < 30
      o
    }
    @invalid_set = FuzzyLogic::Set.new { |n|
      "Hallo Welt"
    }
    @msg = "Test-Fuzzy-Set should be"
  end

  def test_ranges_of_fuzzyset
    assert(@a_set.get(30) == 1, "#{ @msg } 1 with .get(35) as input")
    assert(@a_set.get(0) == 0, "#{ @msg } 0 with .get(0) as input")
    assert(@a_set.get(20) == 0, "#{ @msg } 0 with .get(20) as input")

    bgr_than_zero = @a_set.get(20.1)
    assert(bgr_than_zero > 0, "#{@msg } bigger than 0 with .get(20.1) as input")
    assert(bgr_than_zero < 0.3, "#{ @msg} smaller than 0.3 with .get(20.1) as input")

    sml_than_one = @a_set.get(29.9)
    assert(sml_than_one < 1, "#{@msg } smaller than 1 with .get(29.9) as input")
    assert(sml_than_one > 0.7, "#{@msg} bigger than 0.7 with .get(29.9) as input")
  end

  def test_ranges_with_alphacut
    assert(@a_set.get(20.1, 0.5) == 0, "#{@msg} be zero with alphacut")
    assert(@a_set.get(26, 0.5) > 0 , "#{@msg} be bigger than zero with alphacut")
  end

  def test_invalid_values
    assert_raises(ArgumentError) {
      @a_set.get(Object.new)
    }
    assert_raises(TypeError) {
      @invalid_set.get(3)
    }
    assert_raises(ArgumentError) {
      @a_set.get(3, true)
    }
  end
end
