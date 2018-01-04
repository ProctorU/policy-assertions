require 'test_helper'

class MultipleAssertionsTest < Minitest::Test
  def test_assert_multiple_permissions_pass
    test_runner = policy_class do
      def test_index_and_create
        assert_permit User.new, Article
      end
    end.new :test_index_and_create

    test_runner.run
    assert test_runner.passed?
  end

  def test_assert_multiple_permissions_fail
    test_runner = policy_class do
      def test_index_and_create
        assert_permit nil, Article
      end
    end.new :test_index_and_create

    test_runner.run
    refute test_runner.passed?
  end

  def test_refute_multiple_permissions_pass
    test_runner = policy_class do
      def test_index_and_create
        refute_permit nil, Article
      end
    end.new :test_index_and_create

    test_runner.run
    refute test_runner.passed?
  end

  def test_refute_multiple_permissions_fail
    test_runner = policy_class do
      def test_index_and_create
        refute_permit User.new, Article
      end
    end.new :test_index_and_create

    test_runner.run
    refute test_runner.passed?
  end
end

class AssertionsTest < Minitest::Test
  def test_long_permission_names
    test_runner = policy_class do
      def test_long_action_and_index
        assert_permit nil, Article
      end
    end.new :test_long_action_and_index

    test_runner.run
    assert test_runner.passed?
  end

  def test_permission_passed
    test_runner = policy_class do
      def test_create
        assert_permit User.new, Article
      end
    end.new :test_create

    test_runner.run
    assert test_runner.passed?
  end

  def test_permission_failed_expected_to_pass
    test_runner = policy_class do
      def test_create
        assert_permit nil, Article
      end
    end.new :test_create

    test_runner.run
    refute test_runner.passed?
  end

  def test_permission_passed_expected_to_fail
    test_runner = policy_class do
      def test_create
        refute_permit User.new, Article
      end
    end.new :test_create

    test_runner.run
    refute test_runner.passed?
  end

  def test_permission_failed
    test_runner = policy_class do
      def test_create
        refute_permit nil, Article
      end
    end.new :test_create

    test_runner.run
    assert test_runner.passed?
  end

  def test_permission_failed_as_assert_not_permitted
    test_runner = policy_class do
      def test_create
        assert_not_permitted nil, Article
      end
    end.new :test_create

    test_runner.run
    assert test_runner.passed?
  end

  def test_destroy
    test_runner = policy_class do
      def test_destroy
        assert_permit User.new(100), Article.new(100)
      end
    end.new :test_destroy

    test_runner.run
    assert test_runner.passed?
  end
end

class StrongParametersTest < Minitest::Test
  def test_strong_parameters_pass
    test_runner = policy_class do
      def test_strong_parameters
        allowed = [:user_id, :title, :description]
        assert_strong_parameters User.new(1), Article, Article.params, allowed
      end
    end.new :test_strong_parameters

    test_runner.run
    assert test_runner.passed?
  end

  def test_strong_parameters_fail
    test_runner = policy_class do
      def test_strong_parameters
        assert_strong_parameters nil, Article, Article.params, [:user_id]
      end
    end.new :test_strong_parameters

    test_runner.run
    refute test_runner.passed?
  end
end

class DifferentClassNameTest
  class FakePolicyTest < PolicyAssertions::Test
    def test_strong_parameters
      allowed = [:user_id, :title, :description]
      assert_strong_parameters User.new(1), Article, Article.params, allowed
    end
  end
end

class InvalidBlockParametersTest
  class ArticlePolicyTest < PolicyAssertions::Test
    test 'index?' do
      assert_raises(PolicyAssertions::MissingBlockParameters) do
        assert_permit nil, Article
      end
    end
  end
end

class DefinedPolicyClassTest
  class PersonPolicyTest < PolicyAssertions::Test
    def test_create_and_destroy
      assert_permit User.new(100), User.new(101)
    end

    def test_strong_parameters
      assert_strong_parameters nil, User, User.params, [:user_id, :name]
    end
  end
end

# rubocop:disable Style/ClassAndModuleChildren:
class ModularizedPolicyClassTest
  class Users::SessionPolicyTest < PolicyAssertions::Test
    def test_create_and_destroy
      assert_permit User.new(100), Users::Session.new(100)
    end

    def test_destroy
      refute_permit User.new(100), Users::Session.new(101)
      refute_permit nil, Users::Session.new
    end

    def test_strong_parameters
      assert_strong_parameters User.new,
                               Users::Session,
                               Users::Session.params,
                               [:id, :user_id]
    end
  end
end

class ValidBlockParametersTest
  class ArticlePolicyTest < PolicyAssertions::Test
    test 'index?' do
      assert_permit nil, Article, 'index?', 'long_action?'
    end

    test 'destroy?' do
      refute_permit nil, Article, 'destroy?'
    end

    test 'destroy? with assert_not_permitted' do
      assert_not_permitted nil, Article, 'destroy?'
    end
  end
end
