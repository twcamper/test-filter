require 'test/unit'

module Test::Unit
  class TestCase

    # command line arguments which could be individual test method names
    @@args = Array.new(ARGV)
    
    # list of 1 or more test method names to follow a test file name
    def TestCase.cmd_line_tests
      @@args.select {|arg| arg =~ /^test_[\w_]+$/}
    end

    def TestCase.tests_per_class=(tests_per_class)
      @@tests_per_class = tests_per_class
    end

    def TestCase.tests_per_class
      @@tests_per_class ||= {}
    end

    def self.filtered_test_method_names
      # did Rakefile make a filtered tests hash from the declarations in the files?
      unless TestCase.tests_per_class.empty?
        #  is this class in the hash?
        return TestCase.tests_per_class[name] if TestCase.tests_per_class[name]
        #  was the test file loaded but all of the test methods excluded somehow?
        return []
      end
    end

    def TestCase.total_test_count
      @@total_test_count ||= 0
    end
  
    def TestCase.add_to_total_test_count(count_to_add)
      @@total_test_count = total_test_count + count_to_add
    end
  
    def run_count
      @_result.run_count + 1
    end
  
    # for each TestCase.suite
    def self.all_test_method_names
      @all_test_method_names ||= public_instance_methods(true).select {|m| m =~ /^test_/}
    end
  
    # gets tests from TestCase.suite or from the command line
    def self.tests
      tests = filtered_test_method_names || all_test_method_names
      # intersection of arrays: remove any tests not on the command line
      return (tests & cmd_line_tests) unless cmd_line_tests.empty?
      
      return tests
    end
  
    # * collects test method names into suite object
    # * accumulates total test count from mulitple suites
    def self.suite
      suite = TestSuite.new(name)
      tests.sort.each do |test|
        catch(:invalid_test) do
          suite << new(test)
        end
      end
      
      add_to_total_test_count(suite.tests.size) unless suite.empty?
      return suite
    end
  
    def teardown
      if run_count.eql?(TestCase.total_test_count)
        # last test in suite has run: do suite level cleanup
        # $selenium.stop
        # report
      end
    end
  end
end
