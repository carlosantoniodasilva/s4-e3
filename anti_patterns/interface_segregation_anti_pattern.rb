# ISP - The Interface Segregation Principle
# Make fine grained interfaces that are client specific.

require "minitest/autorun"

class User
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

class Category
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

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
        to_search(object)
      end.join(" ")
    end

    def to_search(object)
      case object
      when User then
        "u:#{object.name}"
      when Category
        "c:#{object.name}"
      else
        "#{object.first}:#{object.last}"
      end
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

    it "builds a search query based on an array of arrays" do
      builder  = Search::Builder.new
      query    = builder.build([["u", "carlos"], ["c", "technology"]])

      assert_equal "u:carlos c:technology", query
    end

    it "accepts users and category objects to build the query" do
      builder  = Search::Builder.new
      user     = User.new("carlos")
      category = Category.new("technology")
      query    = builder.build([user, category])

      assert_equal "u:carlos c:technology", query
    end
  end
end
