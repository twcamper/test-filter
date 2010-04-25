     #Tags: file 

class StringVariationsTest < Test::Unit::TestCase
  def test_match_a #tags: lower_case_no_spaces
    lorem = "ipsum"
  end
  
  def test_match_b #Tags: capitalized_no_spaces
    lorem = "ipsum"
  end

  def test_match_c #  tags: lower_case_with_spaces
    lorem = "ipsum"
  end

  def test_match_d #TAGS: upper_case_no_spaces
    lorem = "ipsum"
  end

  def test_match_e #   TAGS: upper_case_with_spaces
    lorem = "ipsum"
  end

  def test_match_f #tAgs: mixed_case_no_spaces
    lorem = "ipsum"
  end
  
  def test_match_g#Tags: no_space_after_test_name
    lorem = "ipsum"
  end

  def test_no_match_a #Tags : space_before_colon
    lorem = "ipsum"
  end

  def test_no_match_a #Tags  no_colon
    lorem = "ipsum"
  end
  

end
