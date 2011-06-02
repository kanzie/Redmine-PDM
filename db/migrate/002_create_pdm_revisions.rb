class CreatePdmRevisions < ActiveRecord::Migration
  def self.up
    create_table :pdm_revisions do |t|
      t.column :commit_message, :string
      t.column :created_by, :string
      t.column :created_date, :datetime
      t.column :pdm_document_id, :int
    end
  end

  def self.down
    drop_table :pdm_revisions
  end
end
