#Tags: file file_and_method

class SameTagOnFileAndMethodTest < Test::Unit::TestCase
  def test_b #tags: method file_and_method
    lorem = "ipsum"
    loquitor = 13
    
    assert_not_equal(lorem, loquitor, "mixed types")
  end
  
  def test_c #tags: method
    lorem = "ipsum"
    loquitor = 13
    
    assert_not_equal(lorem, loquitor, "mixed types")
  end
  
end