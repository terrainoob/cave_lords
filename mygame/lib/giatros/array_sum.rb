module Giatros
  Array.define_method :sum do
    raise TypeError, "TypeError (method :sum was called on " +
      "an empty Array): [].sum" if self.empty?
    raise TypeError, "TypeError (method :sum was called on " +
      "an Array containing non-numeric types):\n#{self.inspect}.sum"\
        if self.any?{|value| !(Numeric === value)}
    return self.first if self.length == 1
    return self.reduce{|sum, summand| sum + summand}
  end
end
