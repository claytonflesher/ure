require "ure/version"

class Ure  
  def initialize(fields:)
    @fields = fields
    set_attributes

    freeze
  end

  def [](key)
    @fields[key]
  end

  def each(&block)
    if block_given?
      @fields.each_value { |value| yield(value) }
    else
      @fields.each_value
    end
  end

  def each_pair(&block)
    if block_given?
      @fields.each_pair { |key, value| yield(key, value) }
    else
      @fields.each_pair
    end
  end

  def to_s
    @fields.to_s
  end

  def inspect
    to_s
  end

  def length
    @fields.length
  end

  def members
    @fields.keys
  end

  def select(&block)
    if block_given?
      @fields.values.select { |value| yield(value) }
    else
      @fields.values.select
    end
  end

  def size
    length
  end

  def to_a
    @fields.values.to_a
  end

  def to_h
    @fields.to_h
  end

  def values
    @fields.values
  end

  def values_at(index, *args)
    list = []
    list << @fields.values[index]
    args.each do |arg|
      list << @fields.values[arg]
    end
    list
  end

  private

  def set_attributes
    @fields.each do |key, value|
      unless self.respond_to?(key, include_all=true)
        self.define_singleton_method(key) { value }
      else
        raise "#{key} is already an existing method!"
      end
    end
  end
end
