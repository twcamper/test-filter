# Copyright 2010 ThoughtWorks, Inc. Licensed under the Apache License, Version 2.0.

class TestFileReader
  DEF_PATTERN = /^[^#]*def\s+([\w_]+)/i
  END_PATTERN = /^\s*end\s*(#.*)?/

  TAG_PATTERN       = /\#\s*tags:(.+)$/i  # matches test method lines too
  TEST_PATTERN      = /^[^#]*def\s+(test_\w+)/i      # test method declarations that are NOT commented
  FILE_TAG_PATTERN  = Regexp.new("^\s*" + TAG_PATTERN.source, "i")
  CLASS_DEF_PATTERN = /^[^#]*class\s+(\w+)\s*<\s*Test::Unit::TestCase/
  STANDALONE_TAG_PATTERN = FILE_TAG_PATTERN

  attr_reader :name, :methods_and_tags

  def initialize(file_name)
    @name = file_name
    @line_numbers_to_tag_arrays = {}
    @test_method_ranges = []

    begin
      parse_file(@name)
    rescue Exception => ex
      puts "error parsing file: #{@name}"
      raise ex
    end
    
    @methods_and_tags = map_tags_to_methods
=begin
    @name             = file_name
    lines             = File.read(@name).split(/\n/)
    @methods_and_tags = read_test_tags(lines)
    @class_name       = read_class_name(lines) || file_name_as_class_name
=end
  end

=begin
  def read_test_tags(lines)
    file_tags = [] # file tags: tests will inherit these
    lines.each do |line| 
      line =~ FILE_TAG_PATTERN
      file_tags.concat List.tag_list($1) if $1
    end

    tests_and_tags = {}

    lines.each do |line| 
      next unless line =~ TEST_PATTERN

      # test names: some will have their own tags to be combined with the file level tags    
      test_name = $1.downcase                                   # should strip away everything but the test method name

      if line =~ TAG_PATTERN  
        # set union ( '|' operator on Array), in case of duplicates across file and method
        tests_and_tags[test_name] = file_tags | List.tag_list($1) # $1 should get test level tags, only
      else
        tests_and_tags[test_name] = file_tags
      end
    end
    return tests_and_tags
  end
=end

  # A procedural approach: act on each line once and only once
  #
  #   1 - save off class name if it's present
  #
  #   2 - prepare array of MethodLineRange objects
  #
  #   3 - prepare hash of line numbers with tag arrays from those lines
  def parse_file(file_name)
    lines_with_end = []

    f = File.open(file_name)
    f.each do |line|
      if line =~ CLASS_DEF_PATTERN
        @class_name = $1
      end

      if line =~ STANDALONE_TAG_PATTERN
        @line_numbers_to_tag_arrays[f.lineno] = List.tag_list($1)
      end

      if line =~ DEF_PATTERN
        last_method = $1
        if @last_method_is_test = (last_method =~ /^test_/)
          @line_numbers_to_tag_arrays[f.lineno] = List.tag_list($1) if line =~ TAG_PATTERN
          @test_method_ranges.last.close(lines_with_end.last) unless lines_with_end.empty?
          @test_method_ranges << MethodLineRange.new(last_method, f.lineno)
        end
      elsif @last_method_is_test && line =~ END_PATTERN 
        lines_with_end << f.lineno
      end
    end

    unless lines_with_end.empty?
      lines_with_end.pop if @last_method_is_test
      @test_method_ranges.last.close(lines_with_end.last)
    end
  end

  # first, map method level tags to test method names, removing those tag lines as we go
  #
  # then, any remaining tag lines are considered file or class level tags and added to each methods tags
  #
  # one known glitch:  if a non-test method has tags for some reason they will be considered file/class level
  def map_tags_to_methods
    tests_and_tags = {}
    @test_method_ranges.each do |test_method|
      tests_and_tags[test_method.name] = []
      tag_lines_in_range = @line_numbers_to_tag_arrays.select { |key, value| test_method.line_range.include? key }
      tag_lines_in_range.each do |line_number, tag_array|
        tests_and_tags[test_method.name] |= tag_array
        @line_numbers_to_tag_arrays.delete(line_number)
      end
    end

    file_level_tags = @line_numbers_to_tag_arrays.values.flatten
    tests_and_tags.keys.each do |test_name|
      tests_and_tags[test_name] |= file_level_tags
    end

    return tests_and_tags
  end

  def class_name
    @class_name || file_name_as_class_name
  end

=begin
  def read_class_name(lines)
    lines.find {|line| line =~ CLASS_DEF_PATTERN}
    $1 
  end
=end
  def file_name_as_class_name
    @name.split("/").last.gsub(/\.rb/, "").to_class_name
  end

  def include?(tag)
    tag_pattern = tag.instance_of?(Regexp) ? tag : Regexp.new(tag)
    tags.grep(tag_pattern).empty? == false
  end

  def tags
    methods_and_tags.values.flatten
  end

  class MethodLineRange
    attr_reader :name, :line_range
    def initialize(name, first_line)
      @name = name
      @first_line = first_line
    end

    def close(last_line)
      begin
        @line_range = (@first_line..last_line)
      rescue Exception => ex
        puts "'last_line' value: #{last_line.inspect}"
        puts ex.class
        raise ex
      end
    end
  end
end

