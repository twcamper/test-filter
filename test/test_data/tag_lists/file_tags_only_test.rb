#Tags: file smoke

class FileOnlyTest < Test::Unit::TestCase
  def test_my_file_has_tags
    lorem = "ipsum"
    loquitor = 13
    
    assert_not_equal(lorem, loquitor, "mixed types")
  end
  
  def test_my_file_also_has_tags
    lorem = "ipsum"
    loquitor = 13
    
    assert_not_equal(lorem, loquitor, "mixed types")
  end
  
end