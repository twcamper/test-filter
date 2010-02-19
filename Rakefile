require 'rake/testtask'

FILE_PATTERN = '**/*{u,i}test.rb'

desc "unit tests"
Rake::TestTask.new do |t|
  t.libs << "."
  t.test_files = FileList[FILE_PATTERN]
  t.verbose = true
end

desc "run a test method or class"
task :run_by_name, [:test_name] do |t, args|
  require 'rake/runtest'

  tf = TestFilter.new(:file_pattern => FILE_PATTERN, :test_name_white_list => args.test_name)
  Rake.run_tests(FILE_PATTERN)
end
