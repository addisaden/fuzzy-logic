# encoding: utf-8

require_relative "../fuzzy-logic.rb"

module FuzzyLogic
  class Set
    attr_reader :height

    def initialize(height=nil, &fuzzyproc)
      @fuzzyproc = fuzzyproc
      @height = height
    end

    def get(value, alphacut=nil)
      raise ArgumentError, "Value of fuzzy-set should be Comparable" unless value.is_a? Comparable
      out = @fuzzyproc.call(value)

      raise TypeError, "output of fuzzy-set should be Numeric" unless out.is_a? Numeric

      @height ||= out
      @height = out if out > @height

      if alphacut then
        raise ArgumentError, "Alphacut of fuzzy-set should be Comparable" unless alphacut.is_a? Comparable
      	out = 0 if alphacut > out
      end

      return out
    end
  end
end
