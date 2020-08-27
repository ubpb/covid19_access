class User < ApplicationRecord

  # Validations
  validates :uid, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  def name
    [first_name, last_name].map(&:presence).compact.join(" ").presence
  end

  def name_reversed
    [last_name, first_name].map(&:presence).compact.join(", ").presence
  end

end
