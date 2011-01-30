# LSP - The Liskov Substitution Principle
# Derived classes must be substitutable for their base classes.

require "minitest/autorun"

class Search
  def initialize(options={})
    @builder = (options[:builder] || Builder).new
  end

  def build(objects)
    @builder.build(objects)
  end

  class Builder
    def build(hash)
      hash.map { |item| build_item(item) }.join(" ")
    end

    def build_item(item)
      key, value = item
      "#{key}:#{value}"
    end
  end
end

class User
  class SearchBuilder < Search::Builder
    def build_item(user)
      "u:#{user.name}"
    end
  end

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def self.build_search(users)
    search = Search.new(:builder => SearchBuilder)
    search.build(users)
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
end

describe User do
  it "builds the search query based on a list of users" do
    user1 = User.new("carlos")
    user2 = User.new("antonio")
    query = User.build_search([user1, user2])

    assert_equal "u:carlos u:antonio", query
  end
end
