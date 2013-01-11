# encoding: utf-8

=begin

  TODO: Build a Fuzzy-Set-Generator with a list as arguments ...

  temp[:warm] = fuzzy_set_generator( [28,1], [15,0] )
  temp[:cold] = fuzzy_set_generator( [0, 1], [15,0] )

  temp[:mid] = fuzzy_set_and(fuzzy_set_complement(temp[:warm]), fuzzy_set_complement(temp[:cold]))
  
  
  
  Generate a better view ...
  
  TODO: Optimize Output to something like This:

    0  3  6  9 12 15 18 21 24 27 30
                    ---~~~+++oooOOO warm
  OOOooo+++~~~---                   cold

X  <=   >
O - 1.-.8
o - .8-.6
+ - .6-.4
~ - .4-.2
- - .2-.0
  - .0

=end

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

      raise TypeError, "output of fuzzy-set should be Comparable" unless out.is_a? Comparable

      @height ||= out
      @height = out if out > @height

      if alphacut then
        raise ArgumentError, "Alphacut of fuzzy-set should be Comparable" unless alphacut.is_a? Comparable
      	out = 0 if alphacut > out
      end

      return out
    end
  end

  module Generate
    def self.gauss
    end

    def self.triangle(center, range)
      range = range.abs
      return Set.new(1) { |n|
        o = 0.0
	      if n == center then
	        o = 1.0
	      elsif n.between?((center-range/2.0), (center+range/2.0)) then
	        o = 1.0 - [1.0, (n - center).abs.to_f/(range/2.0)].min
	      end
	      o
      }
    end

    def self.trapezoid(supmin, cormin, cormax, supmax)
      supmin, cormin, cormax, supmax = *([supmin, cormin, cormax, supmax].sort.map(&:to_f))
      return Set.new(1) { |n|
        o = 0.0
        if n.between?(cormin,cormax) then
          o = 1.0
        elsif n.between?(supmin,cormin) then
          o = 1 - (cormin - n)/(cormin - supmin)
        elsif n.between?(cormax,supmax) then
          o = 1 - (n - cormax)/(supmax - cormax)
        end
        o
      }
    end

    def self.singleton
    end

    def self.list
    end
  end
end

temp = {}

temp[:warm] = Proc.new { |n|
  out = 0
  if n >= 28
    out = 1
  elsif n < 28 and n >= 15
    out = 1 - (28.0-n)/(28.0-15)
  end
  out
}

temp[:cold] = Proc.new { |n|
  out = 0
  if n <= 0
    out = 1
  elsif n < 15 and n >= 0
    out = 1 - n/15.0
  end
  out
}

temp[:mid] = Proc.new { |n|
  [(1 - temp[:cold].call(n)),(1 - temp[:warm].call(n))].min
}

temp[:cool] = Proc.new { |n|
  temp[:mid].call(n)*temp[:cold].call(n)*4
}


(0..30).to_a.each { |inp|
  next if inp % 2 == 1
  puts "--- Testing #{ inp } °C"

  tp = nil

  temp.each { |n,f|
    tp ||= [n, f.call(inp)]
    if f.call(inp) > tp.last then
      tp = [n, f.call(inp)]
    end
    puts "Is the weather #{ n }?\t%.2f" % f.call(inp)
  }

  puts "\nOn #{inp} °C the weather is #{ tp.first }!\n\n"
}
