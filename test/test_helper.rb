require 'minitest/autorun'
require 'minitest/pride'
require 'policy_assertions'
require 'pundit'

ActiveSupport::TestCase.test_order = :random

# create a dynamic class using the passed in block
# and names it correctly
def policy_class(&block)
  klass = Class.new(PolicyAssertions::Test, &block)
  def klass.name
    'ArticlePolicyTest'
  end

  klass
end

class User
  attr_accessor :id

  def initialize(id = nil)
    @id = id if id
  end
end

class Article
  attr_accessor :user_id

  def initialize(user_id)
    @user_id = user_id
  end

  def self.params
    { :user_id => 1, :title => 'title', :description => 'test description' }
  end
end

class ArticlePolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def long_action?
    true
  end

  def create?
    @user
  end

  def destroy?
    @user && @user.id == @record.user_id
  end

  def permitted_attributes
    (@user && @user.id == 1) ? [:user_id, :title, :description] : [:title]
  end
end
