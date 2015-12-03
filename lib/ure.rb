require "ure/version"
require "json"
##
# Immutable alternative to Struct that requires keyword arguments
class Ure < BasicObject
  include ::Enumerable

  ##
  # Returns the ure members as an array of symbols.
  def self.members
    @members.freeze
  end

  ##
  # Create an ure named by its constant.
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

      members.each do |member|
        define_method member.to_sym do
          fields[member.to_sym]
        end

        define_method :"#{member}=" do |_|
          ::Kernel.fail "can't modify frozen #{self}"
        end
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

    members.freeze

    members.each do |member|
      ::Kernel.fail ::ArgumentError, "missing keyword: #{member}" unless fields.include?(member)
    end

    unless (extra = fields.keys - members).empty?  
      ::Kernel.fail ::ArgumentError, "unknown keyword#{'s' if extra.size > 1}: #{extra.join(', ')}"
    end

    @fields = fields.freeze
  end

  attr_reader :fields

  ##
  # Equality---Returns true if other has the same ure subclass and has equal member values.
  def ==(arg)
    if self.class == arg.class
      fields == arg.fields
    else
      false
    end
  rescue ::NoMethodError
    false
  end

  ##
  # Because Ure doesn't care about indexing, this allows users to treat instances of Ure as a hash.
  def [](key)
    fields[key]
  end

  ##
  # Converts the fields into a hash and calls each on them.
  def each(&block)
    to_h.each(&block)
  end

  ##
  # Returns a string describing the object and its fields
  def to_s
    "#<#{::Ure} #{self.class} #{fields.to_s}"
  end

  ##
  # Returns a string describing the object and its fields
  def inspect
    "#<#{::Ure} #{self.class} #{fields.to_s}"
  end

  ##
  # Alias for #values
  def to_a
    fields.values
  end

  ##
  # Alias for #fields
  def to_h
    fields.to_h
  end

  ##
  # Returns an array of the values in the fields
  def values
    fields.values
  end

  ##
  # Takes one or more keys as arguments, and returns an array of the corresponding values.
  def values_at(name, *args)
    [fields[name]] + args.map { |arg| fields[arg] }
  end

  ##
  # Returns a JSON string of members and values.
  def to_json
    fields.to_json
  end
end
