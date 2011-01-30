# ISP - The Interface Segregation Principle
# Make fine grained interfaces that are client specific.

require "minitest/autorun"

class Search
  def initialize(options={})
    @parser = (options[:parser] || Parser).new
  end

  def parse(query)
    @parser.parse(query)
  end

  class Parser
    def parse(query)
      Hash[*split_values(query).flatten]
    end

    protected

    def split_values(query)
      query.split(/\s/).map { |value| value.split(":") }
    end
  end

  class SortedParser < Parser
    def split_values(query)
      super.sort_by { |k, v| k }
    end
  end
end

describe Search do
  describe "default parser" do
    it "parses the given query and returns a hash of options" do
      search  = Search.new
      options = search.parse("u:carlos c:technology")

      assert_equal 2, options.size
      assert_equal "carlos", options["u"]
      assert_equal "technology", options["c"]
      assert_equal ["u", "c"], options.keys
    end
  end

  describe "sorted parser" do
    it "parses the given query and returns a hash of options sorted by key" do
      search  = Search.new(:parser => Search::SortedParser)
      options = search.parse("u:carlos c:technology")

      assert_equal 2, options.size
      assert_equal "carlos", options["u"]
      assert_equal "technology", options["c"]
      assert_equal ["c", "u"], options.keys
    end
  end
end
