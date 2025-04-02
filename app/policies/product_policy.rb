# frozen_string_literal: true

class ProductPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    true
  end

  def destroy?
    true
  end

  def permitted_attributes_for_create
    if user.is_admin?
      %i[name category code units users_score price description image location real_price sold_units]
    else
      %i[name category code units users_score price description image]
    end
  end

  def permitted_attributes_for_update
    if user.is_admin?
      %i[name category units users_score price description image location real_price sold_units]
    else
      %i[name category units users_score price description image]
    end
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
