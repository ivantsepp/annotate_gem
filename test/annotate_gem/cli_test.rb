require "test_helper"
require "annotate_gem/cli"

# Acts as integration test since it will actually fetch data from API
class AnnotateGem::CLITest < Minitest::Test

  def test_run_for_gemfile
    with_gemfile(File.read(gemfile_path)) do |path|
      Bundler.expects(:default_gemfile).returns(Pathname.new(path)).at_least_once
      out, _ = capture_io do
        AnnotateGem::CLI.new.run_for_gemfile
      end
      assert_equal File.read(annotated_gemfile_path), File.read(path)
    end
  end

  def test_run_for_gem
    out, _ = capture_io do
      AnnotateGem::CLI.new.run_for_gem("annotate_gem")
    end
    assert_equal "Add comments to your Gemfile with each dependency's description. (https://github.com/ivantsepp/annotate_gem)\n", out
  end
end
