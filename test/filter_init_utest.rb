require 'test/unit'
require 'test_filter'


class FilterInitTest < Test::Unit::TestCase
  
  FILE_PATTERN = "**/*_test.rb"

  def test_dir_glob_filter_returns_test_files_and_not_others
    tf = TestFilter.new(:file_pattern => "**/*_test.rb")

    assert_equal([], tf.globbed_files.select {|f| f !~ /_test.rb$/})
    assert_equal(tf.globbed_files, tf.globbed_files.reject {|f| f !~ /_test.rb$/})
  end

  def test_initialize_filter
    tf = TestFilter.new()
    assert_equal([], tf.any, "any")
    assert_equal([], tf.all, "all")
    assert_equal([], tf.none, "none")
    assert_equal(TestFilter::DEFAULT_FILE_PATTERN, tf.file_pattern, "file_pattern")

    tf = TestFilter.new(:file_pattern => "**/*_test.rb")
    assert_equal([], tf.any, "any")
    assert_equal([], tf.all, "all")
    assert_equal([], tf.none, "none")
    assert_equal("**/*_test.rb", tf.file_pattern, "file_pattern")

    tf = TestFilter.new(:any => "smoke")
    assert_equal(["smoke"], tf.any, "any")
    assert_equal([], tf.all, "all")
    assert_equal([], tf.none, "none")
    assert_equal(TestFilter::DEFAULT_FILE_PATTERN, tf.file_pattern, "file_pattern")

    tf = TestFilter.new(:any => ["red", "blue", "yellow"], :all => ["smoke", "ad.hoc"])
    assert_equal(["red", "blue", "yellow"], tf.any, "any")
    assert_equal(["smoke", "ad.hoc"], tf.all, "all")
    assert_equal([], tf.none, "none")
    assert_equal(TestFilter::DEFAULT_FILE_PATTERN, tf.file_pattern, "file_pattern")

    tf = TestFilter.new(:none => %w{broken ad.hoc})
    assert_equal([], tf.any, "any")
    assert_equal([], tf.all, "all")
    assert_equal(["broken", "ad.hoc"], tf.none, "none")
    assert_equal(TestFilter::DEFAULT_FILE_PATTERN, tf.file_pattern, "file_pattern")

    tf = TestFilter.new(:none => 13.5, :any => :foo, :all => "fealty")
    assert_equal(["foo"], tf.any, "any")
    assert_equal(["fealty"], tf.all, "all")
    assert_equal(["13.5"], tf.none, "none")
    assert_equal(TestFilter::DEFAULT_FILE_PATTERN, tf.file_pattern, "file_pattern")

    tf = TestFilter.new(:all => ["pie", "cake", "bon-bon"], :none => %w{broken ad.hoc}, :any => ["sales", "booking", "fern_bar"], :file_pattern => "**/**globbity/glob*.rb")

    assert_equal(["sales", "booking", "fern_bar"], tf.any, "any")
    assert_equal(["pie", "cake", "bon-bon"], tf.all, "all")
    assert_equal(["broken", "ad.hoc"], tf.none, "none")
    assert_equal("**/**globbity/glob*.rb", tf.file_pattern, "file_pattern")
  end

end
