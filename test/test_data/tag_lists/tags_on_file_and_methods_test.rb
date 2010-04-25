#Tags: file

class TagsOnBothTest < Test::Unit::TestCase
  def test_two_tags_on_me #tags: method broken
    lorem = "ipsum"
    loquitor = 13
    
    assert_not_equal(lorem, loquitor, "mixed types")
  end
  
  def test_one_tag_on_me #tags: method
    lorem = "ipsum"
    loquitor = 13
    
    assert_not_equal(lorem, loquitor, "mixed types")
  end
  
end