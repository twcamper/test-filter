class String
  def to_class_name
    gsub(/(^|_)([a-zA-Z])/) {$2.upcase}
  end

  def to_flower_box(character = "*")
    message = "#{character}  #{self}  #{character}"
    flower_box_line = character * message.size
    flower_box_line + "\n" + message + "\n" + flower_box_line
  end
end
