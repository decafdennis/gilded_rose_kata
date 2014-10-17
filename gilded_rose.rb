require 'value'

def update_quality(items)
  items.each do |item|
    sell_in = SellInValue.of(item).decreases
    quality = QualityValue.of(item).degrades.is_never_negative.is_never_more_than(50)

    quality.degrades_twice_as_fast if sell_in.has_passed?

    case item.name
    when /Aged Brie/
      quality.improves_with_age

    when /Sulfuras/
      sell_in.never_changes
      quality.never_changes

    when /Backstage passes/
      if sell_in.has_passed?
        quality.drops_to_zero
      else
        quality.improves_by 3 - (item.sell_in / 5).floor
      end

    when /Conjured/
      quality.degrades_twice_as_fast

    else
      # Intentionally left blank.
    end
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

