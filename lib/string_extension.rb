class String
  def to_class_name
    gsub(/(^|_)([a-zA-Z])/) {$2.upcase}
  end
end
