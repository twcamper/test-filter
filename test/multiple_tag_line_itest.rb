require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + '/../lib/test_filter')
require 'verifications'

class MultipleTagLineIntegrationTest < Test::Unit::TestCase
  include TestFilterVerifications

  def test_include_based_on_two_file_tag_lines
    tf = TestFilter.new(:file_pattern => "**/multiple_file_level_tag_lines/*_test.rb", :any => %w{line_1 line2 line_2_other}, :none => "the_fleet")
    expected_files =  %w{test_data/multiple_file_level_tag_lines/one_test.rb
                         test_data/multiple_file_level_tag_lines/two_test.rb}
    verify_test_files(expected_files, tf.filtered_files)
    expected_tests = {"MultipleOne"             => ["test_the_first", "test_the_second"],
                      "MultipleTwo"               => ["test_jingle"]}
    verify_test_lists(expected_tests, tf.filtered_tests)
  end

  def test_exclude_based_on_file_line_1
    tf = TestFilter.new(:file_pattern => "**/multiple_file_level_tag_lines/*_test.rb", :none => "line_1")
    expected_files =  %w{test_data/multiple_file_level_tag_lines/two_test.rb}
    verify_test_files(expected_files, tf.filtered_files)
    expected_tests = {"MultipleTwo"               => ["test_pickwick", "test_jingle"]}
    verify_test_lists(expected_tests, tf.filtered_tests)
  end

  def test_include_based_on_file_line_3
    tf = TestFilter.new(:file_pattern => "**/multiple_file_level_tag_lines/*_test.rb", :any => "line_3")
    expected_files =  %w{test_data/multiple_file_level_tag_lines/two_test.rb}
    verify_test_files(expected_files, tf.filtered_files)
    expected_tests = {"MultipleTwo"               => ["test_pickwick", "test_jingle"]}
    verify_test_lists(expected_tests, tf.filtered_tests)
  end

  def test_all_method_tag_lines_found
    tf = TestFileReader.new(Dir["**/multiple_method_level_tag_lines/*_test.rb"].first)

    assert_equal([], tf.methods_and_tags.values.flatten & %w{end_line other_end_line})
    assert_equal(["body_line_1", "body_line_2", "file", "method_line", "thing.sub_thing"], tf.methods_and_tags["test_name_line_and_body_lines"].sort)
    assert_equal(["file", "thing.sub_thing.negative"], tf.methods_and_tags["test_body_lines_only"].sort)
  end
end
