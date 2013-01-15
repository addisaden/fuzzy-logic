# encoding: utf-8

require_relative "../fuzzy-logic.rb"

module FuzzyLogic
  module Generate
    def self.gauss
      #
      # Gauss would be calculated with this expression:
      #
      # Math.exp(
      #   -( (n - center)/diffusion )**2
      # )
      #
      # Problem: On an overange feedback are big numbers instead of zero
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

    def self.singleton(*args)
      args_test_array_filled_with_arrays_length(args, "Arguments of a singleton fuzzy-set should be Arrays of length 2", 2)

      args = args.sort { |a,b| a.first <=> b.first }
      max = args.collect { |a| a.last } .sort.last

      return Set.new(max) { |n|
        o = 0.0
        args.each { |a|
          if n == a.first then
            o = a.last.to_f
            break
          end
        }
        o
      }
    end

    def self.list(*args)
      args_test_array_filled_with_arrays_length(args, "Arguments of a list fuzzy-set should be Arrays of length 2", 2)
    end

    def self.or(seta, setb, soft=false)
      raise ArgumentError, "Arguments should be fuzzy-sets" unless seta.is_a? Set and setb.is_a? Set
      
      h1 = seta.height || 0
      h2 = setb.height || 0
      
      hmax = [h1,h2].max
      hmax = hmax > 0 ? hmax : nil

      if soft then
        return Set.new(hmax) { |n|
          seta.get(n) + setb.get(n) - seta.get(n) * setb.get(n)
        }
      end

      return Set.new(hmax) { |n|
        [seta.get(n), setb.get(n)].max
      }
    end

    def self.and(seta, setb, soft=false)
      raise ArgumentError, "Arguments should be fuzzy-sets" unless seta.is_a? Set and setb.is_a? Set

      if soft then
        return Set.new { |n|
          seta.get(n) * setb.get(n)
        }
      end

      return Set.new { |n|
        [seta.get(n), setb.get(n)].min
      }
    end

    def self.not(seta)
      raise ArgumentError, "Argument should be a fuzzy-set" unless seta.is_a? Set

      return Set.new { |n|
        1 - seta.get(n)
      }
    end

    private

    def self.args_test_array_filled_with_arrays_length(args, msg, len)
      raise ArgumentError, msg unless args.select { |arg|
        (not arg.is_a? Array) or (not arg.length == len)
      }.empty?
    end
  end
end
