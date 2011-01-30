# ISP - The Interface Segregation Principle
# Make fine grained interfaces that are client specific.

require "minitest/autorun"

class Search
  def initialize
    @builder = Builder.new
  end

  def build(objects)
    @builder.build(objects)
  end

  class Builder
    def build(objects)
      objects.map do |object|
        if object.respond_to?(:to_search)
          object.to_search
        else
          "#{object.first}:#{object.last}"
        end
      end.join(" ")
    end
  end
end

class User
  def initialize(name)
    @name = name
  end

  def to_search
    "u:#{@name}"
  end
end

class Category
  def initialize(name)
    @name = name
  end

  def to_search
    "c:#{@name}"
  end
end

describe Search do
  describe Search::Builder do
    it "builds a search query based on a hash of options" do
      builder = Search::Builder.new
      query   = builder.build("u" => "carlos", "c" => "technology")

      assert_equal "u:carlos c:technology", query
    end

    it "builds a search query based on an array of arrays" do
      builder  = Search::Builder.new
      query    = builder.build([["u", "carlos"], ["c", "technology"]])

      assert_equal "u:carlos c:technology", query
    end

    it "accepts any object that responds to :to_search to build the query" do
      builder  = Search::Builder.new
      user     = User.new("carlos")
      category = Category.new("technology")
      query    = builder.build([user, category])

      assert_equal "u:carlos c:technology", query
    end
  end
end
