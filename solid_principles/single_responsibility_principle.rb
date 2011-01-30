# SRP - The Single Responsibility Principle
# A class should have one, and only one, reason to change.

require "minitest/autorun"

class Search
  def initialize
    @builder = Builder.new
    @parser  = Parser.new
  end

  def build(hash)
    @builder.build(hash)
  end

  def parse(query)
    @parser.parse(query)
  end

  class Builder
    def build(hash)
      hash.map { |key, value| "#{key}:#{value}" }.join(" ")
    end
  end

  class Parser
    def parse(query)
      Hash[*query.split(/\s/).map do |value|
        value.split(":")
      end.flatten]
    end
  end
end

describe Search do
  describe Search::Builder do
    it "builds a search query based on a hash of options" do
      builder = Search::Builder.new
      query   = builder.build("u" => "carlos", "c" => "technology")

      assert_equal "u:carlos c:technology", query
    end
  end

  describe Search::Parser do
    it "parses the given query and returns a hash of options" do
      parser  = Search::Parser.new
      options = parser.parse("u:carlos c:technology")

      assert_equal 2, options.size
      assert_equal "carlos", options["u"]
      assert_equal "technology", options["c"]
    end
  end
end
