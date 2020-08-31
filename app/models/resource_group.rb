class ResourceGroup < ApplicationRecord

  # Relations
  has_many :resources

  # Validations
  validates :title, presence: true

end
