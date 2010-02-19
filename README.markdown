*TestFilter*
## builds a list of matching test files and a hash which maps test class names to lists of included test method.  Currently, only `Test::Unit` is supported, but `Rspec` support wouldn't be difficult.

Test files may be tagged, with this convention:

    #Tags: smoke book_customer Find.Customer Story.1234 defect.98

Any line beginning with `[optional white space]#Tags:` anywhere within the file except within a test method def applies to the whole file.  This means that it applies to the
test class, and that only one test class per file is supported.

Multiple tag lines are also supported.

To tag an individual method, do this:

    def test_foo #Tags: broken find_module.defect.1322
      #Tags: long_tag_describing_precise_functionality
      . . .
      . . .
    end

See the dummy test files under test/test_data for the tagging possibilities, and test/**_{i,u}test.rb for TestFilter usage.

One way to filter tests for execution is to extend (ok, monkey patch) `Test::Unit` as shown in `testcase_demo/testcase.rb`, run the filter in a `rake` task, and set `TestCase.tests_per_class`.

    FILE_PATTERN = "./**/*_test.rb"

    task :customer_smoke do
      require 'rake/runtest'
    
      tf = TestFilter.new(:file_pattern => FILE_PATTERN, :all => ['smoke', 'find.customer'], :none => ['dev', 'broken', 'deferred'])
      Test::Unit::TestCase.tests_per_class = tf.filtered_tests
      Rake.run_tests(FILE_PATTERN)
    end


