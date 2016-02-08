require 'minitest/autorun'
require 'minitest/pride'
require 'policy_assertions'

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
  def self.policy_class
    PersonPolicy
  end

  attr_accessor :id

  def initialize(id = nil)
    @id = id if id
  end

  def self.params
    { :user_id => 1, :name => 'name', :role => 'admin' }
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

class PersonPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def create?
    true
  end

  def destroy?
    @user
  end

  def permitted_attributes
    (@user && @user.id == 1) ? [:user_id, :name, :role] : [:user_id, :name]
  end
end

module Users
  class Session
    attr_accessor :id, :user_id

    def initialize(user_id = nil)
      @id = random_id
      @user_id = user_id || random_id
    end

    def self.params
      { :id => @id, :user_id => @user_id, :name => 'session_name' }
    end

    private

    def random_id
      100 + Random.rand(1000)
    end
  end

  class SessionPolicy
    attr_reader :user, :record

    def initialize(user, record)
      @user = user
      @record = record
    end

    def create?
      @user
    end

    def destroy?
      @user && @user.id == record.user_id
    end

    def permitted_attributes
      return [] unless @user
      @user.id == 1 ? [:id, :user_id, :name] : [:id, :user_id]
    end
  end
end
