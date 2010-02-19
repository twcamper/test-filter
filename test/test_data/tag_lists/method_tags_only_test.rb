
class MethodTagsOnlyTest < Test::Unit::TestCase
  def test_my_file_has_no_tags #tags: method file_or_method smoke
    lorem = "ipsum"
    loquitor = 13
    
    assert_not_equal(lorem, loquitor, "mixed types")
  end
  
  def test_no_good_anymore #tags: obsolete
    lorem = "ipsum"
    loquitor = 13
    
    assert_not_equal(lorem, loquitor, "mixed types")
  end
  
end