# Ure

Ure is a Ruby Gem that fixes the biggest problems with Struct, namely the lack of immutability and required keyword arguments.

For example, you can do this with Struct:

```ruby
Car = Struct.new(:paint, :year)
=> Car
scooby_van = Car.new
=> #<struct Car paint=nil, year=nil>
```

Even worse, what if we include one argument and forget the other?

```ruby
myster_machine = Car.new(:mural)
=> #<struct Car paint=:mural, year=nil>
```
Fixing it with Struct's built-in accessors after the fact isn't great, either. What we want is a Struct that has required arguments, and then throws a useful error if we give it the wrong thing.

That's where Ure comes in.

First, let's show a successful implementation of the same thing in Ure.

```ruby
require 'ure'
=> true
Car = Ure.new(:paint, :year)
=> Car
scooby_van = Car.new(year: 1965, paint: :mural)
=> #ure {:year=>1968, :paint=>:mural}
```
Notice that it no longer matters what order `:year` and `:paint` are given to `Car`, because we have keyword arguments.

But that's not all. 

```ruby
mystery_machine = Car.new
NameError: uninitialized constant Ure::ArgumentError
```

We get a useful error message, instead of a data object populated with `nil`'s.

Also, what happens if we try to change the values in an existing Ure data object?

```ruby
scooby_van = Car.new(year: 1965, paint: :mural)
=> #ure {:year=>1968, :paint=>:mural}
scooby_van.year = 2000
NoMethodError: undefined method `year=' for #<ure {:year=>1965, :paint=>:mural}
```
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ure'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ure

## Usage

To use Ure, just require it in whatever file is implementing it and treat it like a Struct.

Ure will try to implement as public methods whatever keys you pass in as a hash. For speed purposes, this means that if you pass in an existing method that Ure recognizes, it'll override it. Ure inherits directly from `BasicObject`, so it has very few methods other than its public facing instance methods. Still, this is something to watch out for. If you're passing in `:instance_eval` or a lone `!` as keys, you'll have problems.

Any methods on `Struct` that require indexing or care about the position of arguments have been depricated or changed to only care about the name of the argument passed.

Ure's current public methods are:

`#[]` - Because Ure doesn't care about indexing, this allows users to treat instances of Ure as a hash.

`#each(&block) - Converts the fields into a hash and calls each on them.

`#to_s` - Returns a string describing the object and its fields.

`#inspect`- Alians for `.to_s`

`#to_a` - Alias for `.values`.

`#to_h` - Returns a hash of the fields.

`#values` - Returns an array of the values in the fields.

`#values_at` - Takes one or more keys as arguments, and returns an array of the corresponding values.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Calvyn82/ure. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

