
class TestNameMatcher

  CLASS_PATTERN            = /^\w+test$/i
  METHOD_PATTERN           = /^test\w+$/
  CLASS_DOT_METHOD_PATTERN = /^\w+_?test\.test_\w+$/i

  # for a legitimate Ruby constant, which could be a class name that doesn't end in "Test"
  CONSTANT_PATTERN         = /^[A-Z]\w*$/

  def initialize(list, pattern = nil)
    @list = List.make(list)
    @pattern = pattern
  end

  def match?(test_class, test_method)
    (@pattern && (test_class =~ @pattern || test_method =~ @pattern)) ||
    @list.find { |item| matches_name_list_item?(item, test_class, test_method)}
  end

  private
  # we can list classes, methods, or class.methods
  def matches_name_list_item?(item, test_class, test_method)
    name_list_item = item.to_s
    case name_list_item
    when CLASS_DOT_METHOD_PATTERN
      name_list_class, name_list_method = name_list_item.split(".")
      name_list_class.to_class_name == test_class && name_list_method == test_method
    when METHOD_PATTERN
      name_list_item == test_method
    when CLASS_PATTERN, CONSTANT_PATTERN
      name_list_item.to_class_name == test_class
    end
  end
end
