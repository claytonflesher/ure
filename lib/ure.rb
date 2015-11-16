require "ure/version"
require "json"
class Ure < BasicObject
  include ::Enumerable
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

      parent_class = self

      define_method(:class) do
        parent_class
      end

      class_eval(&body) if body
    end
  end

  def initialize(fields = {})
    ::Kernel.fail ::ArgumentError, "'fields' must be a 'Hash'" unless fields.is_a?(::Hash)

    members.each do |member|
      ::Kernel.fail ::ArgumentError, "missing keyword: #{member}" unless fields.include?(member)
      instance_eval <<-END_RUBY
      def #{member}
        fields[#{member.inspect}]
      end
      END_RUBY
    end

    unless (extra = fields.keys - members).empty?  
      ::Kernel.fail ::ArgumentError, "unknown keyword#{'s' if extra.size > 1}: #{extra.join(', ')}"
    end

    @values = fields
  end

  attr_reader :fields, :class

  def fields
    @values
  end

  def ==(arg)
    if self.class == arg.class
      fields == arg.fields
    else
      false
    end
  rescue ::NoMethodError
    false
  end

  def [](key)
    fields[key]
  end

  def each(&block)
    to_h.each(&block)
  end

  def to_s
    "#<#{::Ure} #{self.class} #{fields.to_s}"
  end

  def inspect
    "#<#{::Ure} #{self.class} #{fields.to_s}"
  end

  def to_a
    fields.values
  end

  def to_h
    fields.to_h
  end

  def values
    fields.values
  end

  def values_at(name, *args)
    [fields[name]] + args.map { |arg| fields[arg] }
  end

  def to_json
    fields.to_json
  end
end
