# SRP - The Single Responsibility Principle
# A class should have one, and only one, reason to change.

require "minitest/autorun"

class Search
  def build(hash)
    hash.map { |key, value| "#{key}:#{value}" }.join(" ")
  end

  def parse(query)
    Hash[*query.split(/\s/).map do |value|
      value.split(":")
    end.flatten]
  end
end

describe Search do
  it "builds a search query based on a hash of options" do
    builder = Search.new
    query   = builder.build("u" => "carlos", "c" => "technology")

    assert_equal "u:carlos c:technology", query
  end

  it "parses the given query and returns a hash of options" do
    parser  = Search.new
    options = parser.parse("u:carlos c:technology")

    assert_equal 2, options.size
    assert_equal "carlos", options["u"]
    assert_equal "technology", options["c"]
  end
end
