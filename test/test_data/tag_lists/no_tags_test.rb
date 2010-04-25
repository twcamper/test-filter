
class UnTaggedTest < Test::Unit::TestCase
  def test_no_tags_on_me
    lorem = "ipsum"
    loquitor = 13
    
    assert_not_equal(lorem, loquitor, "mixed types")
  end
  
  def test_no_tags_on_me_either #Tags:

    lorem = "ipsum"
    loquitor = 13
    
    assert_not_equal(lorem, loquitor, "mixed types")
  end
  
end