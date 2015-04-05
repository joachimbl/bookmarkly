class LinkPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.visible_for(user)
    end
  end

  def create?
    true
  end

  def update?
    owner?
  end

private

  def owner?
    record.owner?(user)
  end
end
