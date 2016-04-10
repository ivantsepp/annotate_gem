require "test_helper"
require "grub/cli"

# Acts as integration test since it will actually fetch data from API
class Grub::CLITest < Minitest::Test

  def test_run_for_gemfile
    with_gemfile(File.read(gemfile_path)) do |path|
      Bundler.expects(:default_gemfile).returns(path)
      out, _ = capture_io do
        Grub::CLI.new.run_for_gemfile
      end
      assert_equal File.read(grubbed_gemfile_path), File.read(path)
    end
  end

  def test_run_for_gem
    out, _ = capture_io do
      Grub::CLI.new.run_for_gem("grub")
    end
    assert_equal "Add comments to your Gemfile with each dependency's description. (https://github.com/ivantsepp/grub)\n", out
  end
end
