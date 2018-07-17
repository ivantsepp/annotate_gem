[![Build Status](https://travis-ci.org/ivantsepp/annotate_gem.svg?branch=master)](https://travis-ci.org/ivantsepp/annotate_gem)
[![Gem Version](https://badge.fury.io/rb/annotate_gem.svg)](https://badge.fury.io/rb/annotate_gem)

# AnnotateGem

`annotate-gem` is command line tool that will add useful comments to your Gemfile. For each gem, `annotate-gem` will create a comment with the gem's description and the gem's website. For example, a Gemfile containing the following

```ruby
gem "rails"
gem "nokogiri"
gem "brakeman"
```

will be converted into something that is more descriptive and is self-documenting:

```ruby
# Full-stack web application framework. (http://www.rubyonrails.org)
gem "rails"
# Nokogiri (鋸) is an HTML, XML, SAX, and Reader parser
gem "nokogiri"
# Security vulnerability scanner for Ruby on Rails. (http://brakemanscanner.org)
gem "brakeman"
```

The motivation for `annotate-gem` is that developers often open a Gemfile and not know what many of the listed gems are actually for. It's hard to track down which gem is providing which functionality. This is a common problem since many gem names do not reflect the actual feature.

If you do _not_ want to install the gem, you can also visit <https://annotate-gem.herokuapp.com/> which is a web interface for `annotate-gem`.

## Installation

```
$ gem install annotate_gem
```

## Usage

Running `annotate-gem` itself will add comments to the current directory's `Gemfile`.

```
$ cat Gemfile
source 'https://rubygems.org'
gem "pry"
$ annotate-gem
$ cat Gemfile
source 'https://rubygems.org'
# An IRB alternative and runtime developer console (http://pryrepl.org)
gem "pry"
```

`annotate-gem` has several options:

```
$ annotate_gem --help
  Add comments to your Gemfile with each dependency's description.
        Usage: annotate_gem [options]
               annotate_gem [gem name]
        --website-only               Only output the website
        --description-only           Only output the description
        --new-comments-only          Only add a comment to gemfile if there isn't a comment already (for non-inline comments)
        --inline                     Inline the comment
    -h, --help                       Show this message
    -v, --version                    Show version
```

`annotate-gem` also works with specifying a single gem name:

```
$ annotate-gem aasm
State machine mixin for Ruby objects (https://github.com/aasm/aasm)
```

## Contributing

1. Fork it ( https://github.com/ivantsepp/annotate_gem/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
