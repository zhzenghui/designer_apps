class CreateSoftwares < ActiveRecord::Migration
  def change
    create_table :softwares do |t|
      t.integer :app_id
      t.string :app_name
      t.string :app_spell

      t.timestamps
    end
  end
end
