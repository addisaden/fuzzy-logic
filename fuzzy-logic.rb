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
  end

  module Generate
    def self.gauss
    end

    def self.triangle
    end

    def self.trapezoid
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
