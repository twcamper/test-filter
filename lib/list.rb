
# Ensure array list format, given a nil, a space-delimited string, a single number, a single symbol, or an array
module List
  # dowcases all strings
  def List.tag_list(future_tag_list)
    List.make(future_tag_list).collect {|e| e.respond_to?(:downcase) ? e.downcase : e }
  end

  def List.make(future_list)
    case future_list
    when Array
      future_list
    when String
      future_list.split(" ")
    when Numeric, Symbol
      [future_list.to_s]
    else
      []
    end
  end
end
