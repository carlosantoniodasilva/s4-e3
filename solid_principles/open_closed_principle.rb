# OCP - The Open Closed Principle
# You should be able to extend a classes behavior, without modifying it.

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
      Hash[*split_values(query).flatten]
    end

    def split_values(query)
      query.split.map { |value| value.split(":") }
    end
  end

end

class SortingSearch < Search
  def initialize
    @parser = SortingParser.new
  end

  class SortingParser < Parser
    def split_values(query)
      super.sort_by { |k, v| k }
    end
  end
end

describe Search do
  describe Search::Parser do
    it "parses the given query and returns a hash of options" do
      parser  = Search::Parser.new
      options = parser.parse("u:carlos c:technology")

      assert_equal 2, options.size
      assert_equal "carlos", options["u"]
      assert_equal "technology", options["c"]
      assert_equal ["u", "c"], options.keys
    end
  end
end

describe SortingSearch do
  describe SortingSearch::SortingParser do
    it "parses the given query and returns a hash of options sorted by key" do
      parser  = SortingSearch::SortingParser.new
      options = parser.parse("u:carlos c:technology")

      assert_equal 2, options.size
      assert_equal "carlos", options["u"]
      assert_equal "technology", options["c"]
      assert_equal ["c", "u"], options.keys
    end
  end
end
