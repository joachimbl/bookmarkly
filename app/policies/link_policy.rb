class LinkPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.visible_for(user)
    end
  end

  def create?
    user.present?
  end

  def update?
    owner?
  end

  def add?
    create? && !owner?
  end

  def remove?
    owner? or user.email == "joachim.blicher@gmail.com"
  end

private

  def owner?
    record.owner?(user)
  end
end
