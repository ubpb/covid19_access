class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  strip_attributes collapse_spaces: true
end
