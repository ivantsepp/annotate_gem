require "test_helper"

class Grub::GemfileTest < Minitest::Test

  def test_parses_source
    gemfile = gemfile_for(unindent(<<-GEMFILE))
      hello
      world!
    GEMFILE
    assert 2, gemfile.source.length
    assert_equal "hello\n", gemfile.source.first
    assert_equal "world!\n", gemfile.source.last
  end

  def test_parses_gem_lines
    Grub::GemLine.expects(:new).with(
      name: "rails",
      original_line: "gem \"rails\"\n",
      location: 0,
      prev_line_comment: nil,
      options: {}
    ).once
    Grub::GemLine.expects(:new).with(
      name: "grub",
      original_line: "gem \"grub\"\n",
      location: 2,
      prev_line_comment: "# this gem has a comment\n",
      options: {}
    ).once
    gemfile = gemfile_for(unindent(<<-GEMFILE))
      gem "rails"
      # this gem has a comment
      gem "grub"
      # gem "commented_out"
    GEMFILE
    assert_equal 2, gemfile.gem_lines.length
  end

  def test_write_comments
    with_gemfile("gem 'rails'") do |path|
      gemfile = Grub::Gemfile.new(path)
      gemfile.gem_lines = [mock(location: 0, comment: "Rails description!\n", should_insert?: true)]
      gemfile.source = ["gem 'rails'"]
      gemfile.write_comments
      assert_equal "Rails description!\ngem 'rails'", File.read(path)
    end
  end

  def test_that_options_are_passed_through
    Grub::GemLine.expects(:new).with(
      name: "rails",
      original_line: "gem 'rails'",
      location: 0,
      prev_line_comment: nil,
      options: { description_only: true }
    ).once
    gemfile = gemfile_for("gem 'rails'", description_only: true)
  end

  private

  def gemfile_for(content, options = {})
    gemfile = nil
    with_gemfile(content) do |path|
      gemfile = Grub::Gemfile.new(path, options)
      gemfile.parse
    end
    gemfile
  end

end
