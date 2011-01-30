# DIP - The Dependency Inversion Principle
# Depend on abstractions, not on concretions.

require "minitest/autorun"

class Search
  def initialize
    @parser = Parser.new
  end

  def parse(query)
    @parser.parse(query)
  end

  class Parser
    def parse(query)
      Hash[*query.split(/\s/).map { |value| value.split(":") }.flatten]
    end
  end
end

describe Search do
  it "parses the given query and returns a hash of options" do
    search  = Search.new
    options = search.parse("u:carlos c:technology")

    assert_equal 2, options.size
    assert_equal "carlos", options["u"]
    assert_equal "technology", options["c"]
    assert_equal ["u", "c"], options.keys
  end
end
