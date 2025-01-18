# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

slicers = Slicer.create([
  # {name: "PrusaSlicer", uri: "prusaslicer://open?file="}, # Not possible right now https://github.com/prusa3d/PrusaSlicer/issues/13752
  # {name: "Bambu Studio", uri: "bambustudio://open?file="}, # Not possible until this is merged https://github.com/bambulab/BambuStudio/pull/5347
  # {name: "Bambu Studio", uri: "bambustudioopen://file="},  # Not possible until this is merged https://github.com/bambulab/BambuStudio/pull/5347
  {name: "Orca Slicer", uri: "orcaslicer://open?file=", enabled: true},
  {name: "UltiMaker Cura", uri: "cura://open?file=", enabled: true}
])
