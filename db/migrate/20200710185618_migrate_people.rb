class MigratePeople < ActiveRecord::Migration[6.0]

  class Person < ApplicationRecord ; end

  def up
    Person.all.each do |person|
      Registration.new(person.attributes).save!(validate: false)
    end
  end
end
