# encoding: utf-8

require_relative "spec_helper.rb"
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
      [5,0,-15,15,20].each { |t|
        @triangle.get(t).must_equal 0
      }
    end
  end

  describe "a trapezoid fuzzy-set" do
    it "should have a zone with 1" do
      [20,25,30].each { |t|
        @trapezoid.get(t).must_equal 1
      }
    end

    it "should have also some values near one" do
      @trapezoid.get(19.9).must_be :<, 1
      @trapezoid.get(19.9).must_be :>, 0.9
      @trapezoid.get(30.1).must_be :<, 1
      @trapezoid.get(30.1).must_be :>, 0.9
    end

    it "should have also some values near zero" do
      @trapezoid.get(10.1).must_be :>, 0
      @trapezoid.get(10.1).must_be :<, 0.1
      @trapezoid.get(39.9).must_be :>, 0
      @trapezoid.get(39.9).must_be :<, 0.1
    end

    it "should have a zone with 0" do
      [0, 5, 10, 40, 41, 49, 50].each { |t|
        @trapezoid.get(t).must_equal 0
      }
    end
  end

  describe "a list fuzzy-set" do
    # no test yet - no architecture ...
  end

  describe "combination of fuzzy-sets" do
    before do
      @seta = FuzzyLogic::Generate.trapezoid(10,20,30,40)
      @setb = FuzzyLogic::Generate.trapezoid(30,40,50,60)
    end

    describe "or-combination" do
      before do
        @set_or = FuzzyLogic::Generate.or(@seta, @setb)
        @set_or_soft = FuzzyLogic::Generate.or(@seta, @setb, true)
      end

      it "should raise an ArgumentError on Arguments, which are not a Set" do
        lambda { FuzzyLogic::Generate.or(@seta, 1) }.must_raise ArgumentError
        lambda { FuzzyLogic::Generate.or(:test, @setb) }.must_raise ArgumentError
      end

      it "should return a fuzzy-set" do
        FuzzyLogic::Generate.or(@seta, @setb).must_be :is_a?, FuzzyLogic::Set
      end

      it "should have values of one" do
        [20, 25, 30, 40, 45, 50].each { |i|
          @set_or.get(i).must_equal 1
        }
      end

      it "should have values of zero" do
        [0, 5, 10, 60, 65, 70].each { |i|
          @set_or.get(i).must_equal 0
        }
      end

      it "should have values between one and zero" do
        [11,15,19,31,35,39,51,59].each { |i|
          @set_or.get(i).must_be :>, 0
          @set_or.get(i).must_be :<, 1
        }
      end

      it "can handle a soft mode" do
        @set_or_soft.get(35).must_be :>, 0.5
        @set_or_soft.get(35).must_equal 0.75
      end
    end
  end
end
