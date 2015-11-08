require "ure/version"
class Ure
  def self.members
    @members
  end

  def self.new(*members, &body)
    ::Class.new(self) do
      instance_variable_set(:@members, members)

      def self.new(*args, &block)
        object = allocate
        object.__send__(:initialize, *args, &block) if respond_to?(:initialize, true)
        object
      end 

      define_method(:members) do
        @members ||= members
      end

      class_eval(&body) if body
    end
  end

  def initialize(fields = {})
    fail "'fields' must be a 'Hash'" unless fields.is_a?(::Hash)

    members.each do |member|
      fail ArgumentError, "missing keyword: #{member}" unless fields.include?(member)
      instance_eval <<-END_RUBY
      def #{member}
        i = members.index(#{member.inspect})
        values[i]
      end
      END_RUBY
    end

    unless (extra = fields.keys - members).empty?
      fail ArgumentError,
        "unknown keyword#{'s' if extra.size > 1}: #{extra.join(', ')}"
    end

    @values = fields
    @fields = fields
    freeze
  end

  attr_reader :fields

  def [](key)
    fields[key]
  end

  def each(&block)
    if block_given?
      fields.each_pair { |key, value| yield(key, value) }
    else
      fields.each_pair
    end
  end

  def to_s
    "#<ure #{self.class} #{fields.to_s}"
  end

  def inspect
    to_s
  end

  def to_a
    fields.values.to_a
  end

  def to_h
    fields.to_h
  end

  def values
    fields.values
  end

  def values_at(name, *args)
    list = []
    list << fields[name]
    args.each do |arg|
      list << fields[arg]
    end
    list
  end
end
