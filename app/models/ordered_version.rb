class OrderedVersion
  attr_reader :version

  def initialize(version)
    @version = version
  end

  def <=>(other)
    current, the_other = [self, other].map do |version_model|
      version_model
        .version
        .split(".")
        .map(&:to_i)
    end

    [:first, :second, :third].each do |pos|
      if current.send(pos) != the_other.send(pos)
        return current.send(pos) <=> the_other.send(pos)
      end
    end
    return 0

  end


end
