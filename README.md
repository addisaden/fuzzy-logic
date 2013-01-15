# Fuzzy-Logic

Fuzzy logic is a mathematical concept of fuzzy logical sets.
An element of a fuzzy-set belongs to it in a range between zero and one.

read my [work](http://writedown.eu/wp-content/uploads/2013/01/fuzzy-logik_fuzzy-regeln.pdf) on this topic in german.

## Installation

Add this line to your application's Gemfile:

    gem 'fuzzy-logic'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fuzzy-logic

## Usage

### A simple Fuzzy-Set

    require 'fuzzy-logic'

    its_near_christmas = FuzzyLogic::Set.new(1) { |time|
      # default output is zero
      o = 0.0
      
      # time has to be in december before or at the 24th
      if time.month == 12 and time.day <= 24 then
        # set is completly true when its 20th december or above
        o = 1.0 if time.day >= 20

        # set is fuzzy when its between 6th and 19th
        o = 1.0 - (24.0 - time.day)/(24.0 - 6.0) if time.day >= 6 and time.day < 20.0
      end

      # just the correct return
      o
    }
    
    its_near_christmas.get( Time.now )
    
    its_near_christmas.support( Time.new(2013, 12, 8) ) # => true
    its_near_christmas.support( Time.new(2013, 12, 6) ) # => false
    
    tis_near_christmas.core( Time.new(2013, 12, 23) )   # => true
    its_near_christmas.core( Time.new(2013, 12, 8) )    # => false

### Use Fuzzy-Generators

The return is a normal Fuzzy-Set

    require 'fuzzy-logic'
    
    # generate a triangle
    triangle = FuzzyLogic::Generate.triangle(10, 4) # range is (8..12) and mid is 10 (8 and 12 is zero)
    
    # generate a trapezoid
    trapez   = FuzzyLogic::Generate.trapezoid(10, 20, 30, 40) # ~support(10..40) and core(20..30)
    
    # combinations
    triangle_and_trapez = FuzzyLogic::Generate.and(triangle, trapez)
    triangle_or_trapez  = FuzzyLogic::Generate.or( triangle, trapez)
    not_in_trapez       = FuzzyLogic::Generate.not( trapez )

### Use Fuzzy-Collection

    require 'fuzzy-logic'
    
    temp = FuzzyLogic::Collection.new("temperature in °C") { |testvalue|
      o = true
      if not testvalue.is_a? Numeric then
        o = false
      elsif testvalue > 100 or testvalue < -100 then
        o = false
      end
      o
    }
    
    temp[:hot] = FuzzyLogic::Generate.trapezoid(25, 35, 100, 101)
    temp[:cold] = FuzzyLogic::Generate.trapezoid(-101, -100, 5, 15)
    temp[:cool_to_warm] = FuzzyLogic::Generate.and( FuzzyLogic::Generate.not(temp[:hot]), FuzzyLogic::Generate.not(temp[:cold]))

    temp.get(20)
    # => { :cool_to_warm => 1.0 }

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
