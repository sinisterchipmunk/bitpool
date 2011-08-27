class CreateWorkers < ActiveRecord::Migration
  def self.up
    create_table :bitpool_workers do |t|
      t.string :name
      
      t.references :account
      t.timestamps
    end
  end

  def self.down
    remove_table :bitpool_workers
  end
end
