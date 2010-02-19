
# Tags: file
test_class do
  def test_i_have_method_tags #tags: method broken
    puts "a ruby test"
  end
  
  def test_i_have_no_method_tags #tags: 
    p {:some => :stuff, :in => "a", "hash" => :map}
  end
  
  def other_method_not_test
    true
  end
end
