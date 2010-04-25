require 'test/unit'
require 'test_filter'

class TagListLogicTest < Test::Unit::TestCase
  def test_remove_unless_include_tags_match
    tag_list = ["one", "two", "three"]
    assert_equal(true, TestFilter.new(:any => "four").remove?(tag_list))
    assert_equal(false, TestFilter.new(:any => "two").remove?(tag_list))
    assert_equal(false, TestFilter.new(:any => ["three", "four"]).remove?(tag_list))
  end

  def test_remove_unless_all_tags_match
    tag_list = ["one", "two", "three"]
    assert_equal(true, TestFilter.new(:all => "four").remove?(tag_list))
    assert_equal(false, TestFilter.new(:all => "two").remove?(tag_list))
    assert_equal(false, TestFilter.new(:all => ["two", "one", "three"]).remove?(tag_list))
    assert_equal(false, TestFilter.new(:all => ["three", "two"]).remove?(tag_list))
    assert_equal(true, TestFilter.new(:all => ["three", "four"]).remove?(tag_list))
  end

  def test_remove_if_exclude_tags_match
    tag_list = ["one", "two", "three"]
    assert_equal(false, TestFilter.new(:none => "four").remove?(tag_list))
    assert_equal(true, TestFilter.new(:none => "two").remove?(tag_list))
    assert_equal(true, TestFilter.new(:none => ["three", "four"]).remove?(tag_list))
  end

  def test_remove_if_include_tags_do_not_match_or_exclude_tags_do
    tag_list = ["one", "two", "three"]
    assert_equal(false, TestFilter.new(:any => "one", :none => "four").remove?(tag_list))
    assert_equal(true, TestFilter.new(:any => "one", :none => "three").remove?(tag_list))
    assert_equal(true, TestFilter.new(:any => "four", :none => "two").remove?(tag_list))
  end

  def test_empty_test_tag_list
    tag_list = []
    assert_equal(false, TestFilter.new().remove?(tag_list))
    assert_equal(true, TestFilter.new(:any => "one").remove?(tag_list))
    assert_equal(true, TestFilter.new(:all => "one").remove?(tag_list))
    assert_equal(false, TestFilter.new(:none => "three").remove?(tag_list))
  end

  def test_empty_filter_tag_list
    tag_list = ["one", "two", "three"]
    assert_equal(false, TestFilter.new().remove?(tag_list))
  end

end
