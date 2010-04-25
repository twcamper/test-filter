# tags: file 

class AMethodIsCommentedTest < Test::Unit::TestCase
  def test_visible #tags: method you_can.see.me uncommented
    lorem = "ipsum"
  end
  
#  def test_not_ready #tags: you_cannot_see_me commented
#    s = String.new("One never actually declares a string this way in Ruby")
#  end

end
