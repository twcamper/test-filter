# Copyright 2010 ThoughtWorks, Inc. Licensed under the Apache License, Version 2.0.

$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require 'string_extension'
require 'list'
require 'test_name_matcher'
require 'test_file_reader'

class TestFilter

  DEFAULT_FILE_PATTERN = "**/*_test.rb"

  attr_reader :file_pattern, :any, :all, :none, :test_name_excluder, :test_name_includer

  def initialize(args = {})
    @file_pattern = args[:file_pattern] || DEFAULT_FILE_PATTERN
    @all  = List.tag_list(args[:all]) 
    @any  = List.tag_list(args[:any]) 
    @none = List.tag_list(args[:none])

    @test_name_excluder = TestNameMatcher.new(args[:test_name_black_list], args[:test_name_black_pattern])
    if args[:test_name_white_list] || args[:test_name_white_pattern]
      @test_name_includer = TestNameMatcher.new(args[:test_name_white_list], args[:test_name_white_pattern])
    end
  end
  
  def globbed_files
    Dir.glob(@file_pattern)
  end

  def filtered_files
    filtered_test_files.collect {|test_file| test_file.name}
  end

  def remove?(tag_array)
    remove = false
    
    # are all of the tags in :all in the tests' tags?  delete if not
    unless all.empty?
      remove = true unless (tag_array & all).size == all.size
    end
    
    # are any of the tests' tags in :any?  delete if not
    unless any.empty?
      remove = true if (tag_array & any).empty?
    end
    
    # are any of the tests' tags in :none?  delete if so
    unless none.empty?
      remove = true if (tag_array & none).size > 0
    end
    return remove
  end

  def filtered_test_files
    @filtered_test_files ||= globbed_files.collect do |file_name|
      test_file = TestFileReader.new(file_name)

      # remove test methods that either don't pass the filter or are in the black list
      test_file.methods_and_tags.delete_if do |test_method_name, tag_array| 
        remove?(tag_array) ||

        (test_name_includer && !test_name_includer.match?(test_file.class_name, test_method_name)) ||

        test_name_excluder.match?(test_file.class_name, test_method_name)
      end

      # return test files that still have methods
      test_file unless test_file.methods_and_tags.empty?
    end.compact
  end
  
  def filtered_tests
    tests = {}
    filtered_test_files.each do |test_file| 
      if tests[test_file.class_name]
        # make union of all test methods for duplicate test classes
        tests[test_file.class_name] |= (test_file.methods_and_tags.keys)
      else
        tests[test_file.class_name] = test_file.methods_and_tags.keys
      end
    end
    return tests
  end

  def dump
    puts "TEST FILES".to_flower_box
    filtered_files.print
    puts "TEST CLASSES AND METHODS".to_flower_box
    test_classes = filtered_tests.keys.sort
    test_classes.each do |test_class|
      puts test_class
      filtered_tests[test_class].sort.each {|test_method| puts "\t#{test_method}"}
    end
  end
end
