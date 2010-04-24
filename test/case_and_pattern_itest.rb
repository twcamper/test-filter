require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + '/../lib/test_filter_result')


class CaseAndPatternTest < Test::Unit::TestCase

  def test_all_tags_downcased
    tf = TestFilter.new(:file_pattern => "**/case_and_pattern/case_test.rb")
    tags = TestFilterResult.new(tf).all_tags
    assert_equal([], tags.select {|i| i =~ /[A-Z]+/})
  end

  def test_tags_on_commented_test_not_returned
    tf = TestFilter.new(:file_pattern => "**/case_and_pattern/commented_method_test.rb")
    tags = TestFilterResult.new(tf).all_tags
    assert_equal([], tags & ["commented", "you_cannot_see_me"])
    assert_equal(["file", "method", "uncommented", "you_can.see.me"], tags)
  end
  
  def test_tags_on_other_methods_not_returned
    tf = TestFilter.new(:file_pattern => "**/case_and_pattern/other_methods_tagged_test.rb")
    tags = TestFilterResult.new(tf).all_tags
    assert_equal([], tags & %w{i.am.not.a.test other_method broken})
    assert_equal(["file", "test_method"], tags)
  end

  def test_tag_string_pattern
    expected = %w{capitalized_no_spaces
                  file
                  lower_case_no_spaces
                  lower_case_with_spaces
                  mixed_case_no_spaces
                  no_space_after_test_name
                  upper_case_no_spaces
                  upper_case_with_spaces}

    tf = TestFilter.new(:file_pattern => "**/case_and_pattern/tags_string_variations_test.rb")
    actual = TestFilterResult.new(tf).all_tags

    assert_equal(expected, actual)
    
    assert_equal([], actual & ["space_before_colon", "no_colon"])
  end

end
