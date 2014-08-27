class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.float :number
      t.string :schme
      t.string :them_id
      t.integer :software_id 

      t.timestamps
    end
  end
end
