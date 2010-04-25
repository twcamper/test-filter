require 'test/unit'
require 'test_filter'
require 'verifications'

class FilterByTagListIntegrationTest < Test::Unit::TestCase
  include TestFilterVerifications
  
  FILE_PATTERN = "**/tag_lists/*_test.rb"

  def test_include_filter_on_file_level_tags
    expected_files = %w{test_data/tag_lists/file_tags_only_test.rb
                        test_data/tag_lists/same_tag_on_file_and_method_test.rb
                        test_data/tag_lists/tags_on_file_and_methods_test.rb}

    tf = TestFilter.new(:file_pattern => FILE_PATTERN, :any => ["file"])

    verify_test_files(expected_files, tf.filtered_files)
  end

  def test_include_filter_on_method_level_tags_when_file_tag_is_present
    method_tag_where_file_tags_are_also_present = ["broken"]
    tf = TestFilter.new(:file_pattern => FILE_PATTERN, :any => method_tag_where_file_tags_are_also_present)

    expected_files = %w{test_data/tag_lists/tags_on_file_and_methods_test.rb}
    expected_tests = {"TagsOnBothTest"=>["test_two_tags_on_me"]}

    verify_test_files(expected_files, tf.filtered_files)
    verify_test_lists(expected_tests, tf.filtered_tests)
  end

  def test_include_filter_on_method_level_tags_with_no_file_tag
    tags_at_method_level_only = ["method", "obsolete"]

    tf = TestFilter.new(:file_pattern => FILE_PATTERN, :any => tags_at_method_level_only)

    expected_files = %w{test_data/tag_lists/same_tag_on_file_and_method_test.rb
                        test_data/tag_lists/tags_on_file_and_methods_test.rb
                        test_data/tag_lists/method_tags_only_test.rb}
    expected_tests = {"TagsOnBothTest"             => ["test_two_tags_on_me", "test_one_tag_on_me"],
                      "SameTagOnFileAndMethodTest" => ["test_b", "test_c"],
                      "MethodTagsOnlyTest"         => ["test_no_good_anymore", "test_my_file_has_no_tags"]}

    verify_test_files(expected_files, tf.filtered_files)
    verify_test_lists(expected_tests, tf.filtered_tests)
  end

  def test_exclude_filter_on_file_level_tags
    tf = TestFilter.new(:file_pattern => FILE_PATTERN, :none => ["file"])

    expected_files = %w{test_data/tag_lists/method_tags_only_test.rb
                        test_data/tag_lists/no_tags_test.rb}
    expected_tests = {"UnTaggedTest"       => ["test_no_tags_on_me_either", "test_no_tags_on_me"],
                      "MethodTagsOnlyTest" => ["test_no_good_anymore", "test_my_file_has_no_tags"]}

    verify_test_files(expected_files, tf.filtered_files)
    verify_test_lists(expected_tests, tf.filtered_tests)
  end

  def test_exclude_filter_on_method_level_tags_when_file_tag_is_present
    method_tag_where_file_tags_are_also_present = ["broken"]
    tf = TestFilter.new(:file_pattern => FILE_PATTERN, :none => method_tag_where_file_tags_are_also_present)

    expected_files = %w{test_data/tag_lists/file_tags_only_test.rb
                        test_data/tag_lists/no_tags_test.rb
                        test_data/tag_lists/same_tag_on_file_and_method_test.rb
                        test_data/tag_lists/tags_on_file_and_methods_test.rb
                        test_data/tag_lists/method_tags_only_test.rb}

    expected_tests = {"UnTaggedTest"               => ["test_no_tags_on_me_either", "test_no_tags_on_me"],
                      "TagsOnBothTest"             => ["test_one_tag_on_me"],
                      "FileOnlyTest"               => ["test_my_file_has_tags", "test_my_file_also_has_tags"],
                      "SameTagOnFileAndMethodTest" => ["test_b", "test_c"],
                      "MethodTagsOnlyTest"         => ["test_no_good_anymore", "test_my_file_has_no_tags"]}

    verify_test_files(expected_files, tf.filtered_files)
    verify_test_lists(expected_tests, tf.filtered_tests)
  end

  def test_exclude_filter_on_method_level_tags_with_no_file_tag
    tags_at_method_level_only = ["method", "obsolete"]

    tf = TestFilter.new(:file_pattern => FILE_PATTERN, :none => tags_at_method_level_only)

    ## test_data/tag_lists/method_tags_only_test.rb  added after TAG_PATTERN change
    expected_files = %w{test_data/tag_lists/file_tags_only_test.rb
                        test_data/tag_lists/no_tags_test.rb}
    expected_tests = {"UnTaggedTest" => ["test_no_tags_on_me_either", "test_no_tags_on_me"],
                      "FileOnlyTest" => ["test_my_file_has_tags", "test_my_file_also_has_tags"]}

    verify_test_files(expected_files, tf.filtered_files)
    verify_test_lists(expected_tests, tf.filtered_tests)
  end

  def test_include_and_exclude_method_level
    tf = TestFilter.new(:file_pattern => FILE_PATTERN, :any => ["smoke"], :none => ["obsolete"])

    expected_files = %w{test_data/tag_lists/file_tags_only_test.rb
                        test_data/tag_lists/method_tags_only_test.rb}
    expected_tests = {"FileOnlyTest"       => ["test_my_file_has_tags", "test_my_file_also_has_tags"],
                      "MethodTagsOnlyTest" => ["test_my_file_has_no_tags"]}

    verify_test_files(expected_files, tf.filtered_files)
    verify_test_lists(expected_tests, tf.filtered_tests)

    tf = TestFilter.new(:file_pattern => FILE_PATTERN, :any => ["smoke"], :none => ["obsolete", "method"])

    expected_files = %w{test_data/tag_lists/file_tags_only_test.rb}
    expected_tests = {"FileOnlyTest"       => ["test_my_file_has_tags", "test_my_file_also_has_tags"]}

    verify_test_files(expected_files, tf.filtered_files)
    verify_test_lists(expected_tests, tf.filtered_tests)
  end

  def test_include_and_exclude_file_and_method_level
    tf = TestFilter.new(:file_pattern => FILE_PATTERN, :any => ["smoke", "file"], :none => ["obsolete"])

    expected_files = %w{test_data/tag_lists/file_tags_only_test.rb
                        test_data/tag_lists/method_tags_only_test.rb
                        test_data/tag_lists/same_tag_on_file_and_method_test.rb
                        test_data/tag_lists/tags_on_file_and_methods_test.rb}
    expected_tests = {"TagsOnBothTest"             => ["test_two_tags_on_me", "test_one_tag_on_me"],
                      "FileOnlyTest"               => ["test_my_file_has_tags", "test_my_file_also_has_tags"],
                      "SameTagOnFileAndMethodTest" => ["test_b", "test_c"],
                      "MethodTagsOnlyTest"         => ["test_my_file_has_no_tags"]}
    verify_test_files(expected_files, tf.filtered_files)
    verify_test_lists(expected_tests, tf.filtered_tests)
  end

  def test_method_lists_unify_with_duplicate_class_names
    tf = TestFilter.new(:file_pattern => "**/class_name/duplicate*_test.rb")
    expected_files = %w{test_data/class_name/duplicate_class_name_one_test.rb
                        test_data/class_name/duplicate_class_name_two_test.rb}
    verify_test_files(expected_files, tf.filtered_files)
    verify_test_lists({"DuplicateClassNameTest" => ["test_foo", "test_bar", "test_baz"]}, tf.filtered_tests)
  end

end
