require 'test/unit'
require 'test_filter'
require 'verifications'

class BlackListTest < Test::Unit::TestCase
  include TestFilterVerifications
  
  def test_exclude_one_test_from_class_with_multiple_tests
    file_pattern = "**/*{file_tags_only_test,tags_string_variations_test}.rb"
    expected_files = ["test_data/case_and_pattern/tags_string_variations_test.rb",
                      "test_data/tag_lists/file_tags_only_test.rb"]
    expected_tests = {"StringVariationsTest"       => ["test_match_e", "test_no_match_a", "test_match_f", "test_match_g", "test_match_a", "test_match_b", "test_match_c"],
                      "FileOnlyTest"               => ["test_my_file_also_has_tags", "test_my_file_has_tags"]}
    tf = TestFilter.new(:file_pattern => file_pattern, :test_name_black_list => ["test_match_d"])
    verify_test_files(expected_files, tf.filtered_files)
    verify_test_lists(expected_tests, tf.filtered_tests)

    tf = TestFilter.new(:file_pattern => file_pattern, :test_name_black_list => ["StringVariationsTest.test_match_d"])
    verify_test_files(expected_files, tf.filtered_files)
    verify_test_lists(expected_tests, tf.filtered_tests)

    tf = TestFilter.new(:file_pattern => file_pattern, :test_name_black_list => ["string_variations_test.test_match_d"])
    verify_test_files(expected_files, tf.filtered_files)
    verify_test_lists(expected_tests, tf.filtered_tests)
  end

  def test_exclude_test_with_common_name_from_two_classes
    expected_files = ["test_data/case_and_pattern/case_test.rb",
                      "test_data/black_list/black_list_test_file.rb"]
    expected_tests = {"DuplicateMethodNameTest"    => ["test_mixed_case_tag", "test_capitalized_tag"],
                      "CaseTest"                   => ["test_mixed_case_tag", "test_capitalized_tag"]}
    file_pattern = "**/*{case_test,black_list_test_file}.rb"

    tf = TestFilter.new(:file_pattern => file_pattern, :test_name_black_list => ["test_upper_case_tag"])
    verify_test_files(expected_files, tf.filtered_files)
    verify_test_lists(expected_tests, tf.filtered_tests)

    expected_tests = {"DuplicateMethodNameTest"    => ["test_mixed_case_tag", "test_capitalized_tag", "test_upper_case_tag"],
                      "CaseTest"                   => ["test_mixed_case_tag", "test_capitalized_tag"]}
    tf = TestFilter.new(:file_pattern => file_pattern, :test_name_black_list => ["CaseTest.test_upper_case_tag"])
    verify_test_files(expected_files, tf.filtered_files)
    verify_test_lists(expected_tests, tf.filtered_tests)
  end

  def test_exclude_three_tests_from_different_classes
    expected_files = ["test_data/case_and_pattern/case_test.rb",
                      "test_data/tag_lists/no_tags_test.rb",
                      "test_data/tag_lists/same_tag_on_file_and_method_test.rb"]
    expected_tests = {"UnTaggedTest"               => ["test_no_tags_on_me_either"], 
                      "CaseTest"                   => ["test_upper_case_tag", "test_capitalized_tag"],
                      "SameTagOnFileAndMethodTest" => ["test_c"]}
    file_pattern = "**/*{no_tags,same_tag,case}*_test.rb"
    tf = TestFilter.new(:file_pattern => file_pattern, :test_name_black_list => [:test_b, "test_no_tags_on_me", "test_mixed_case_tag"])
    verify_test_files(expected_files, tf.filtered_files)
    verify_test_lists(expected_tests, tf.filtered_tests)
  end

  def test_black_list_overrides_filter
    file_pattern = "**/*{file_tags_only,same_tag,case}*_test.rb"

    expected_files = ["test_data/tag_lists/file_tags_only_test.rb",
                      "test_data/tag_lists/same_tag_on_file_and_method_test.rb"]
    expected_tests = {"FileOnlyTest"               => ["test_my_file_also_has_tags", "test_my_file_has_tags"],
                      "SameTagOnFileAndMethodTest" => ["test_c", "test_b"]}
    
    tf = TestFilter.new(:file_pattern => file_pattern, :any => ["UPPER.CASE.METHOD.TAG", "file"], :test_name_black_list => ["CaseTest"])
    verify_test_files(expected_files, tf.filtered_files)
    verify_test_lists(expected_tests, tf.filtered_tests)
  end

end

class WhiteListTest < Test::Unit::TestCase
  include TestFilterVerifications
  
  def test_white_list_overrides_filter
    file_pattern = "**/*{file_tags_only,same_tag,case}*_test.rb"

    expected_files = ["test_data/case_and_pattern/case_test.rb"]
    expected_tests = {"CaseTest" => %w[test_upper_case_tag test_mixed_case_tag test_capitalized_tag]}
    
    tf = TestFilter.new(:file_pattern => file_pattern, :any => ["UPPER.CASE.METHOD.TAG", "file"], :test_name_white_list => ["CaseTest"])
    verify_test_files(expected_files, tf.filtered_files)
    verify_test_lists(expected_tests, tf.filtered_tests)
  end

  def test_include_one_class_and_one_test
    expected_files = ["test_data/case_and_pattern/case_test.rb",
                      "test_data/tag_lists/same_tag_on_file_and_method_test.rb"]
    expected_tests = {"CaseTest"               => ["test_capitalized_tag", "test_mixed_case_tag", "test_upper_case_tag"], 
                      "SameTagOnFileAndMethodTest" => ["test_b"]}
    file_pattern = "**/*{no_tags,same_tag,case}*_test.rb"
    tf = TestFilter.new(:file_pattern => file_pattern, :test_name_white_list => ["CaseTest", :test_b])
    verify_test_files(expected_files, tf.filtered_files)
    verify_test_lists(expected_tests, tf.filtered_tests)

  end

  def test_include_on_method_pattern
    expected_files = ["test_data/class_name/class_name_from_file_test.rb",
                      "test_data/tag_lists/tags_on_file_and_methods_test.rb"]
    expected_tests = {"ClassNameFromFileTest" => ["test_i_have_method_tags", "test_i_have_no_method_tags"], 
                      "TagsOnBothTest"        => ["test_one_tag_on_me"]}
    file_pattern = "**/*_test.rb"
    tf = TestFilter.new(:file_pattern => file_pattern, :test_name_white_pattern => /(_method[_\s]|_tag[_\s])/)

    verify_test_files(expected_files, tf.filtered_files)
    verify_test_lists(expected_tests, tf.filtered_tests)
  
  end

end
