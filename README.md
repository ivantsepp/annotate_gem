# Grub

`grub` is command line tool that will add useful comments to your Gemfile. For each gem, `grub` will create a comment with the gem's description and the gem's website. For example, a Gemfile containing the following

```ruby
gem "rails"
gem "nokogiri"
gem "brakeman"
```

will be converted into something that is more descriptive and is self-documenting:

```ruby
# Full-stack web application framework. (http://www.rubyonrails.org)
gem "rails"
# Nokogiri (鋸) is an HTML, XML, SAX, and Reader parser (http://nokogiri.org)
gem "nokogiri"
# Security vulnerability scanner for Ruby on Rails. (http://brakemanscanner.org)
gem "brakeman"
```

The motivation for `grub` is that developers often open a Gemfile and not know what many of the listed gems are actually for. It's hard to track down which gem is providing which functionality. This is a common problem since many gem names do not reflect the actual feature.

If you do _not_ want to install the gem, you can also visit <https://grub-gemfile.herokuapp.com/> which is a web interface for `grub`.

## Installation

```
$ gem install grub
```

## Usage

Running `grub` itself will add comments to the current directory's `Gemfile`.

```
$ cat Gemfile
source 'https://rubygems.org'

# Specify your gem's dependencies in grub.gemspec
gemspec

gem "pry"
$ grub
$ cat Gemfile
source 'https://rubygems.org'

# Specify your gem's dependencies in grub.gemspec
gemspec

# An IRB alternative and runtime developer console (http://pryrepl.org)
gem "pry"
```

`grub` has several options and you can see them via `grub -h`. `grub` also works with specifying a single gem name:

```
$ grub aasm
State machine mixin for Ruby objects (https://github.com/aasm/aasm)
```

## Contributing

1. Fork it ( https://github.com/ivantsepp/grub/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
