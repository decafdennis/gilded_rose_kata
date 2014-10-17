class Value
  # Syntactic sugar.
  def self.of(item)
    new(item)
  end

  def initialize(item)
    @item = item
    @initial_value = item.send("#{key}")
    @delta = 0
  end

  def decreases
    decreases_by 1
  end

  def decreases_by(decrease)
    increases_by -decrease
  end

  def increases
    increases_by 1
  end

  def increases_by(increase)
    update_value do
      @delta = increase
    end
  end

  def is_never_negative
    update_value do
      @min = 0
    end
  end

  def is_never_more_than(max)
    update_value do
      @max = max
    end
  end

  def is(value)
    update_value do
      @forced = value
    end
  end

  def never_changes
    is @initial_value
  end

  protected

  def key
    raise 'Override me!'
  end

  def value
    @forced || [@min || -1e6, @initial_value + @delta, @max || 1e6].sort[1]
  end

  private

  def update_value
    yield if block_given?

    @item.send("#{key}=", value)

    # Allows chaining.
    self
  end
end

class SellInValue < Value
  def has_passed?
    value < 0
  end

  protected

  def key
    :sell_in
  end
end

class QualityValue < Value
  alias_method :degrades, :decreases
  alias_method :degrades_by, :decreases_by
  alias_method :improves, :increases
  alias_method :improves_by, :increases_by

  def degrades_twice_as_fast
    update_value do
      # Multiply only if already degrading.
      @delta *= 2 if @delta < 0
    end
  end

  def drops_to_zero
    is 0
  end

  def improves_with_age
    update_value do
      # Negate only if not improving already.
      @delta = -@delta if @delta < 0
    end
  end

  protected

  def key
    :quality
  end
end
