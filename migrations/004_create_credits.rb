class CreateCredits < ActiveRecord::Migration
  def self.up
    create_table :bitpool_credits do |t|
      t.string :type
      t.integer :count
      t.integer :height
      
      t.references :worker
      t.timestamps
    end
  end

  def self.down
    remove_table :bitpool_credits
  end
end
