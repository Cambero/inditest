# frozen_string_literal: true

class OrderPolicy < ApplicationPolicy
  def index?
    create?
  end

  def show?
    create?
  end

  def create?
    user.is_admin? || record == user
  end

  def destroy?
    create?
  end

  def process_cart?
    create?
  end
end
