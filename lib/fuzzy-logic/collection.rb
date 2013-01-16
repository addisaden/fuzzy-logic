# encoding: utf-8

require_relative "../fuzzy-logic.rb"

module FuzzyLogic
  class Collection
    def initialize(name, &test)
      @name = name
      # a test for inputvariables (returns true/false)
      @test = test
      @sets = {}
    end

    def length
      @sets.count
    end

    def []=(fuzzysetname, fuzzyset)
      raise ArgumentError, "Secound argument should be a Fuzzy-Set" unless fuzzyset.is_a?Set
      @sets[fuzzysetname.to_sym] = fuzzyset
    end

    def [](fuzzysetname)
      @sets[fuzzysetname.to_sym]
    end

    def get(n, all=false)
      raise TypeError, "Test of Fuzzy-Collection is not valid" unless [true, false].include? @test.call(n)
      raise ArgumentError, "Argument is not valid" unless @test.call(n)
      sets_output = {}
      @sets.each { |name, fset|
        x = fset.get(n)
        if x != 0 or all then
          sets_output[name] = x
        end
      }
      sets_output
    end
  end
end
