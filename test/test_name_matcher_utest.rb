
require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + '/../lib/test_filter')

class TestConstructor < Test::Unit::TestCase
  
  def test_initialize
    assert_raise(ArgumentError) {TestNameMatcher.new}
    assert_nothing_raised(ArgumentError) {TestNameMatcher.new([])}
    assert_nothing_raised(ArgumentError) {TestNameMatcher.new([],/./)}
  end

  def test_initialize_empty_inner_object
    tf = TestFilter.new
    assert_kind_of(TestNameMatcher, tf.test_name_excluder)
    assert_kind_of(NilClass, tf.test_name_includer)
    assert_equal([], tf.test_name_excluder.instance_eval("@list"))
    assert_equal(nil, tf.test_name_excluder.instance_eval("@pattern"))
  end

  def test_initialize_inner_object
    black_list = %w[test_foo test_bar FuTest]
    white_list = %w[test_bing test_bob]
    black_pattern = /new_test/
    white_pattern = /old_test/

    tf = TestFilter.new(:test_name_black_list => black_list,
                        :test_name_black_pattern => black_pattern,
                        :test_name_white_list => white_list,
                        :test_name_white_pattern => white_pattern)
    assert_kind_of(TestNameMatcher, tf.test_name_includer)
    assert_equal(black_list, tf.test_name_excluder.instance_eval("@list"))
    assert_equal(black_pattern, tf.test_name_excluder.instance_eval("@pattern"))
    assert_equal(white_list, tf.test_name_includer.instance_eval("@list"))
    assert_equal(white_pattern, tf.test_name_includer.instance_eval("@pattern"))
  end

  def test_initialize_list
    assert_equal(["FooTest", "test_screen_saver"], TestNameMatcher.new(["FooTest", "test_screen_saver"]).instance_eval("@list"))
    assert_equal(["FooTest"], TestNameMatcher.new("FooTest").instance_eval("@list"))
    assert_equal(["FooTest"], TestNameMatcher.new(:FooTest).instance_eval("@list"))
  end

end

class TestSingleItemListMatching < Test::Unit::TestCase
  def setup
    @matcher = TestNameMatcher.new(%w[FooTest.test_foo BarTest.test_foo BobTest test_bing])
  end

  def test_match_class_with_class_notation
    matcher = TestNameMatcher.new("FooTest")
    assert_not_nil(matcher.match?('FooTest', 'test_method'))
    assert_nil(matcher.match?('foo_test', 'test_method'))
  end

  def test_match_class_with_file_notation
    matcher = TestNameMatcher.new("foo_test")
    assert_not_nil(matcher.match?('FooTest', 'test_method'))
    assert_nil(matcher.match?('foo_test', 'test_method'))
  end

  def test_match_method
    matcher = TestNameMatcher.new("test_foo")
    assert_not_nil(matcher.match?('FooTest', 'test_foo'))
    assert_not_nil(matcher.match?('RandomTest', 'test_foo'))
    assert_nil(matcher.match?('FooTest', 'test_bar'))
  end

  def test_match_class_dot_method_with_class_notation
    matcher = TestNameMatcher.new("FooTest.test_foo")
    assert_not_nil(matcher.match?('FooTest', 'test_foo'))
    assert_nil(matcher.match?('foo_test', 'test_foo'))
    assert_nil(matcher.match?('FooTest', 'test_bar'))
  end

  def test_match_class_dot_method_with_file_notation
    matcher = TestNameMatcher.new("foo_test.test_foo")
    assert_not_nil(matcher.match?('FooTest', 'test_foo'))
    assert_nil(matcher.match?('foo_test', 'test_foo'))
    assert_nil(matcher.match?('FooTest', 'test_bar'))
  end

  def test_match_non_convential_class_names
    matcher = TestNameMatcher.new(%w[TestFoo VerifyEverything])
    assert_not_nil(matcher.match?('TestFoo','test_bing'))
    assert_not_nil(matcher.match?('VerifyEverything','test_bing'))
    assert_nil(matcher.match?('verifyEverything','test_bing'))

  end

end

class TestMultiItemListMatching < Test::Unit::TestCase
  def setup
    @matcher = TestNameMatcher.new(%w[FooTest.test_foo BarTest.test_foo BobTest test_bing])
  end

  def test_match_class_dot_method
    assert_not_nil(@matcher.match?("BarTest", "test_foo"))
    assert_not_nil(@matcher.match?("FooTest", "test_foo"))
    assert_nil(@matcher.match?("BingTest", "test_foo"))
    assert_nil(@matcher.match?("FooTest", "test_bob"))
  end

  def test_match_name_or_method
    assert_not_nil(@matcher.match?("FooTest", "test_bing"))
    assert_not_nil(@matcher.match?("BobTest", "test_bing"))
    assert_not_nil(@matcher.match?("BobTest", "test_eek"))
    assert_not_nil(@matcher.match?("EekTest", "test_bing"))
  end

end

class TestPatternMatching < Test::Unit::TestCase

  def test_match_class_pattern
    matcher = TestNameMatcher.new(nil, /Anorak/)
    assert_not_nil(matcher.match?("AnorakFitsTest", "test_foo"))
    assert_not_nil(matcher.match?("LargeAnorakDoesNotFitTest", "test_foo"))
    assert_nil(matcher.match?("CoatTest", "test_anorak_fits"))
  end

  def test_match_pattern_for_multiple_methods
    matcher = TestNameMatcher.new(nil, /(_edit_|_delete_)/)
    assert_nil(matcher.match?("AnorakFitsTest", "test_add_coat_selection"))

    assert_not_nil(matcher.match?("AnorakFitsTest", "test_edit_coat_selection"))
    assert_not_nil(matcher.match?("AnorakFitsTest", "test_nothing_to_delete_if_paid"))
  end
end

class TestPatternAndListMatching < Test::Unit::TestCase

  def test_match_on_listed_name_or_pattern
    matcher = TestNameMatcher.new(["CoatSelectionTest"], /(_edit_|_delete_)/)

    assert_nil(matcher.match?("AnorakFitsTest", "test_add_coat_selection"))
    assert_not_nil(matcher.match?("CoatSelectionTest", "test_add_coat_selection"))
    assert_not_nil(matcher.match?("AnorakFitsTest", "test_nothing_to_delete_if_paid"))
  end
end
