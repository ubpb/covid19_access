class ResourceLocation < ApplicationRecord

  # Relations
  has_many :resources

  # Validations
  validates :title, presence: true


  def deleteable?
    !self.resources.exists?
  end

end
