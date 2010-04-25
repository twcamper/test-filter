#Tags: foo

class DuplicateClassNameTest < Test::Unit::TestCase

  def test_foo
    lorem = "ipsum"
  end

  def test_bar
    lorem = "ipsum"
  end
end
