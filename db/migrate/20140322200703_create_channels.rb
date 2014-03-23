class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.integer :channel
      t.integer :user_1
      t.integer :user_2
    end
  end
end
