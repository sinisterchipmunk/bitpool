class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :bitpool_accounts do |t|
      t.string :key

      t.timestamps
    end
  end

  def self.down
    remove_table :bitpool_accounts
  end
end
