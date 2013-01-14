# encoding: utf-8

require_relative "load_fuzzy_logic.rb"
require "minitest/autorun"

describe FuzzyLogic::Generate do
  before do
    # @gauss
    @triangle = FuzzyLogic::Generate.triangle(10,10)
    @trapezoid = FuzzyLogic::Generate.trapezoid(10,20,30,40)
    # @list
  end

  describe "a gauss fuzzy-set" do
    # no test yet - no architecture ...
  end

  describe "a triangle fuzzy-set" do
    it "should have a point with 1" do
      @triangle.get(10).must_equal 1
    end

    it "should have also some valuse near one" do
      @triangle.get(9.9).must_be :<, 1
      @triangle.get(9.9).must_be :>, 0.8
      @triangle.get(10.1).must_be :<, 1
      @triangle.get(10.1).must_be :>, 0.8
    end

    it "should have also some valuse near zero" do
      @triangle.get(5.1).must_be :>, 0
      @triangle.get(5.1).must_be :<, 0.2
      @triangle.get(14.9).must_be :>, 0
      @triangle.get(14.9).must_be :<, 0.2
    end

    it "should have a zone with 0" do
      @triangle.get(5).must_equal 0
      @triangle.get(0).must_equal 0
      @triangle.get(-15).must_equal 0
      @triangle.get(15).must_equal 0
      @triangle.get(20).must_equal 0
    end
  end

  describe "a trapezoid fuzzy-set" do
  end

  describe "a list fuzzy-set" do
    # no test yet - no architecture ...
  end
end
