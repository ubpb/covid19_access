class FixPy < ActiveRecord::Migration[6.0]
  def up
    Person.where("ilsid like 'PY%'").each do |person|
      ilsid = person.ilsid
      new_ilsid = ilsid.gsub("PY", "PZ")
      person.update(ilsid: new_ilsid)
    end
  end
end
