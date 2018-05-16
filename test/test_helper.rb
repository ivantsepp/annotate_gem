require "minitest/autorun"
require "mocha/minitest"
require "annotate_gem"
require "pry"

module TestHelpers

  def gemfile_path
    File.join(File.dirname(__FILE__), "fixtures", "Gemfile")
  end

  def annotated_gemfile_path
    File.join(File.dirname(__FILE__), "fixtures", "Gemfile_annotated")
  end

  def with_gemfile(content)
    file = Tempfile.new('gemfile')
    file.write(content)
    file.close
    yield(file.path)
    file.unlink
  end

  def unindent(str)
    str.gsub(/^#{str.scan(/^[ ]+(?=\S)/).min}/, "")
  end

end

class Minitest::Test
  include TestHelpers
end
