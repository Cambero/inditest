# frozen_string_literal: true

class ProductPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  class Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user.is_admin?
        scope.all
      else
        scope.kept
      end
    end

    private

    attr_reader :user, :scope
  end
end
