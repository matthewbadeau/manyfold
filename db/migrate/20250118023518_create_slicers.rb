class CreateSlicers < ActiveRecord::Migration[7.2]
  def change
    create_table :slicers do |t|
      t.string :name
      t.string :uri
      t.boolean :enabled, default: true, null: false

      t.timestamps
    end
  end
end
