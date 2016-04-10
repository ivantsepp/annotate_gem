require "test_helper"

class Grub::SpecFinderTest < Minitest::Test
  def test_find_specs_for
    gem_line_1 = mock(spec: nil)
    gem_line_2 = mock(spec: "spec")
    Grub::SpecFinder.expects(:find_matching_specs_for).with([gem_line_1, gem_line_2])
    Grub::SpecFinder.expects(:fetch_specs_for).with([gem_line_1])
    Grub::SpecFinder.find_specs_for([gem_line_1, gem_line_2])
  end

  def test_find_matching_specs_for
    spec_1 = mock
    gem_line_1 = mock(name: "1")
    gem_line_1.expects(:spec=).with(spec_1)
    spec_2 = mock
    gem_line_2 = mock(name: "2")
    gem_line_2.expects(:spec=).with(spec_2)
    gem_lines = [gem_line_1, gem_line_2]
    Gem::Dependency.expects(:new).with("1").returns(mock(matching_specs: [spec_1]))
    Gem::Dependency.expects(:new).with("2").returns(mock(matching_specs: [spec_2]))
    Grub::SpecFinder.find_matching_specs_for(gem_lines)
  end

  def test_fetch_specs_for
    original_stdout = $stdout
    $stdout = StringIO.new

    spec_1 = mock
    gem_line_1 = mock
    gem_line_1.stubs(name: "1")
    gem_line_1.expects(:spec=).with(spec_1)
    spec_2 = mock
    gem_line_2 = mock
    gem_line_2.stubs(name: "2")
    gem_line_2.expects(:spec=).with(spec_2)

    Bundler::Fetcher.any_instance.expects(:fetch_dependency_remote_specs).with(["1", "2"]).returns([[
      ["1", Gem::Version.new("1")],
      ["2", Gem::Version.new("1")],
    ], "dependencies here"])
    Grub::SpecFinder.expects(:find_latest_version).returns(Gem::Version.new("1")).twice
    Bundler::Fetcher.any_instance.expects(:fetch_spec).with(["1", Gem::Version.new("1")]).returns(spec_1)
    Bundler::Fetcher.any_instance.expects(:fetch_spec).with(["2", Gem::Version.new("1")]).returns(spec_2)
    Grub::SpecFinder.fetch_specs_for([gem_line_1, gem_line_2])

    $stdout = original_stdout
  end

  def test_find_latest_version
    versions = [
      ["rails", Gem::Version.new("2.3.5")],
      ["rails", Gem::Version.new("4")]
    ]
    assert_equal Gem::Version.new("4"), Grub::SpecFinder.find_latest_version(versions)
  end
end
