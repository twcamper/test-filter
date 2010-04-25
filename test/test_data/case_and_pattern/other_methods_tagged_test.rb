#Tags: file 

class OtherMethodsTaggedTest < Test::Unit::TestCase
  def test_a #tags: test_method
    lorem = "ipsum"
  end
  
  def non_test_method #Tags: i.am.not.a.test other_method broken
    lorem = "ipsum"
  end

end
