# encoding: utf-8

require_relative "../lib/fuzzy-logic.rb"

tageszeit = FuzzyLogic::Collection.new("Tageszeit") { |n|
  o = false
  if n.is_a? Time then
    o = true
  end
  o
}

morgens_set = FuzzyLogic::Generate.triangle(8, 7)
tageszeit[:morgen] = FuzzyLogic::Set.new(1) { |n|
  morgens_set.get(n.hour + n.min/60.0)
}

mittags_set = FuzzyLogic::Generate.triangle(12, 5)
tageszeit[:mittag] = FuzzyLogic::Set.new(1) { |n|
  mittags_set.get(n.hour + n.min/60.0)
}

nachmittags_set = FuzzyLogic::Generate.triangle(16, 5)
tageszeit[:nachmittag] = FuzzyLogic::Set.new(1) { |n|
  nachmittags_set.get(n.hour + n.min/60.0)
}

abends_set = FuzzyLogic::Generate.triangle(20, 6)
tageszeit[:abend] = FuzzyLogic::Set.new(1) { |n|
  mittags_set.get(n.hour + n.min/60.0)
}

nachts_set_A = FuzzyLogic::Generate.triangle(23.9, 4)
nachts_set_B = FuzzyLogic::Generate.trapezoid(-1,0,5,9)
tageszeit[:nacht] = FuzzyLogic::Set.new(1) { |n|
  t = n.hour + n.min/60.0
  [nachts_set_A.get(t), nachts_set_B.get(t)].max
}

puts "Die aktuelle Tageszeit entspricht: #{ tageszeit.get(Time.now) }"
