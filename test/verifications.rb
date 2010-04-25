
module TestFilterVerifications
  def verify_test_lists(expected, actual)
    assert_equal(expected.keys.sort, actual.keys.sort, "test names")

    expected.each { |test_name, tag_array| assert_equal(tag_array.sort, actual[test_name].sort, "tag array for '#{test_name}'")}
  end

  def verify_test_files(expected_files, filtered_files)
    assert_equal(expected_files.sort, filtered_files.sort)
  end
end
