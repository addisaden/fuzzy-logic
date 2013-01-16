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

require_relative "fuzzy-logic/set.rb"
require_relative "fuzzy-logic/generate.rb"
require_relative "fuzzy-logic/collection.rb"

module FuzzyLogic
  VERSION = "0.0.3"
end
