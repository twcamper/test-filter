#Tags: file 

class MethodsWithManyTest < Test::Unit::TestCase
  def test_name_line_and_body_lines #tags: method_line
    #tags: body_line_1 thing.sub_thing
    lorem = "ipsum"
    #tags: body_line_2
  end #tags: end_line
  
  def test_body_lines_only
    #Tags: thing.sub_thing.negative
    lorem = "ipsum"
  end  # Tags: other_end_line

end
