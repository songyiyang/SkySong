class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.hstore :records
      t.references :user, index: true
      t.text :genre

      t.timestamps
    end
    execute 'CREATE INDEX records_records ON records USING GIN(records)'
  end
end
