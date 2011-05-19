class CreateEngagements < ActiveRecord::Migration
  def self.up
    create_table :engagements do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :engagements
  end
end
