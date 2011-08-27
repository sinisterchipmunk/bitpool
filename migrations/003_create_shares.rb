class CreateShares < ActiveRecord::Migration
  def self.up
    create_table :bitpool_shares do |t|
      t.string :data
      t.integer :height
      t.boolean :accepted, :default => false
      
      t.references :worker
      t.timestamps
    end
  end

  def self.down
    remove_table :bitpool_shares
  end
end
