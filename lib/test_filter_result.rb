require File.expand_path(File.dirname(__FILE__)) + '/test_filter.rb'
class TestFilterResult

  def initialize(test_filter)
    @filter = test_filter
  end

  def filtered_tests
    @filtered_tests ||= @filter.filtered_tests
  end

  def all_tags
    @filter.filtered_test_files.collect {|test_file| test_file.methods_and_tags.values}.flatten.sort.uniq
  end

  def long_test_names_and_tags
    tests_to_tags = {}
    @filter.filtered_test_files.each do |test_file|
      test_file.methods_and_tags.each do |test_method, tag_array|
        tests_to_tags[test_file.class_name + " - " + test_method] = tag_array
      end
    end
    return tests_to_tags
  end

  def tests_per_tag(tag_list = all_tags)
    tags_to_tests = {}
    tag_list.each do |tag|
      tests = []
      long_test_names_and_tags.each do |test_name, tag_array|
         tests << test_name if tag_array.include?(tag)
      end
      tags_to_tests[tag] = tests
    end
    return tags_to_tests
  end 

  def tests_per_filtering_tag
    tests_per_tag(@filter.any + @filter.none)
  end

  def tests_without_stories
    long_test_names_and_tags.reject do |test_name, tag_array|
      tag_array.find {|tag| tag =~ /^[\w.]*story\.\d+/i }
    end
  end

end
