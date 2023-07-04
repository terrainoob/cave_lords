module Giatros
  Array.define_method :median do
    raise TypeError, "TypeError (method :median was called on " +
      "an empty Array): [].median" if self.empty?
    raise TypeError, "TypeError (method :median was called on " +
      "an Array containing non-numeric types):\n#{self.inspect}.median"\
        if self.any?{|value| !(Numeric === value)}
    return self.first.to_f if self.length == 1
    return (self.inject(0, :+) / 2.0) if self.length == 2
    sorted = self.sort
    middleFloor = (self.length - 1) / 2
    output = sorted[middleFloor].to_f
    output = (output + sorted[middleFloor + 1]) / 2.0 if self.length.even?
    return output
  end
end
