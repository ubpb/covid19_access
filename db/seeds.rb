# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Resource.delete_all
ResourceGroup.delete_all
ResourceLocation.delete_all

rg1 = ResourceGroup.create(title: "Einzelarbeitsplatz")
rg2 = ResourceGroup.create(title: "PC-Arbeitsplatz")

rls = ResourceLocation.create([
  {
    title: "Ebene 01, Gebäude J"
  },
  {
    title: "Ebene 02"
  },
  {
    title: "Ebene 02, Gebäude I"
  },
  {
    title: "Ebene 03"
  },
  {
    title: "Ebene 04"
  },
  {
    title: "Ebene 05"
  }
])

rls.each do |rl|
  (1..rand(10..20)).each do |i|
    rl.resources.create(resource_group: rg1, title: "Platz #{i.to_s.rjust(3, "0")}")
  end
end
