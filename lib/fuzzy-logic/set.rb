# encoding: utf-8

require_relative "../fuzzy-logic.rb"

module FuzzyLogic
  class Set
    attr_reader :height

    def initialize(height=nil, &fuzzyproc)
      if height != nil then
        raise ArgumentError, "Initial Height should be numeric" unless height.is_a? Numeric
        raise ArgumentError, "Initial Height should be between 0 and 1" if height < 0 or height > 1
      end
      @fuzzyproc = fuzzyproc
      @height = height
    end

    def support(value, alphacut=nil)
      get(value, alphacut) > 0
    end

    def core(value, alphacut=nil)
      get(value, alphacut) == 1
    end

    def get(value, alphacut=nil)
      raise ArgumentError, "Value of fuzzy-set should be Comparable" unless value.is_a? Comparable
      out = @fuzzyproc.call(value)

      raise TypeError, "Output of fuzzy-set should be Numeric" unless out.is_a? Numeric
      raise TypeError, "Output of fuzzy-set is out of range. Should be between 0 and 1" if out < 0 or out > 1

      @height ||= out
      @height = out if out > @height

      if alphacut then
        raise ArgumentError, "Alphacut of fuzzy-set should be Comparable" unless alphacut.is_a? Numeric
      	out = 0 if alphacut > out
      end

      return out
    end

    def and(other)
      FuzzyLogic::Generate.and(self, other)
    end

    def or(other)
      FuzzyLogic::Generate.or(self, other)
    end

    def not
      FuzzyLogic::Generate.not(self)
    end
  end
end
