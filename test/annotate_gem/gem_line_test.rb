require "test_helper"

class AnnotateGem::GemLineTest < Minitest::Test

  def test_info
    gem_line = create_gem_line
    spec = stub(summary: "Hello world", homepage: "http://example.com")
    gem_line.spec = spec
    assert_equal "Hello world (http://example.com)\n", gem_line.info
  end

  def test_info_with_website_only
    gem_line =  create_gem_line(options: { website_only: true })
    spec = stub(summary: "Hello world", homepage: "http://example.com")
    gem_line.spec = spec
    assert_equal "http://example.com\n", gem_line.info
  end

  def test_info_with_description_only
    gem_line = create_gem_line(options: { description_only: true })
    spec = stub(summary: "Hello world", homepage: "http://example.com")
    gem_line.spec = spec
    assert_equal "Hello world\n", gem_line.info
  end

  def test_should_insert_with_no_info
    gem_line = create_gem_line
    gem_line.expects(:info).returns("")
    refute gem_line.should_insert?
  end

  def test_should_insert_with_no_spec
    gem_line = create_gem_line
    refute gem_line.should_insert?
  end

  def test_should_insert_with_already_added_comment
    gem_line = create_gem_line(prev_line_comment: "# Hello world (http://example.com)\n")
    spec = stub(summary: "Hello world", homepage: "http://example.com")
    gem_line.spec = spec
    refute gem_line.should_insert?
  end

  def test_should_insert_with_new_comments_only
    gem_line = create_gem_line(
      prev_line_comment: "# This is an existing comment\n",
      options: { new_comments_only: true }
    )
    spec = stub(summary: "Hello world", homepage: "http://example.com")
    gem_line.spec = spec
    refute gem_line.should_insert?
  end

  def test_should_insert__with_inline_and_existing_comment
    gem_line = create_gem_line(
      original_line: "gem 'annotate_gem' # This is an existing comment\n",
      options: { inline: true }
    )
    spec = stub(summary: "Hello world", homepage: "http://example.com")
    gem_line.spec = spec
    refute gem_line.should_insert?
  end

  def test_comment
    gem_line = create_gem_line
    spec = stub(summary: "Hello world", homepage: "http://example.com")
    gem_line.spec = spec
    assert_equal "# Hello world (http://example.com)\n", gem_line.comment
  end

  def test_comment_with_indentation_in_original_line
    gem_line = AnnotateGem::GemLine.new(
      name: "annotate_gem",
      original_line: "  \tgem 'annotate_gem'"
    )
    spec = stub(summary: "Hello world", homepage: "http://example.com")
    gem_line.spec = spec
    assert_equal "  \t# Hello world (http://example.com)\n", gem_line.comment
  end

  private

  def create_gem_line(options = {})
    AnnotateGem::GemLine.new(
      { name: "annotate_gem", original_line: "gem 'annotate_gem'" }.merge(options)
    )
  end

end
