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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
