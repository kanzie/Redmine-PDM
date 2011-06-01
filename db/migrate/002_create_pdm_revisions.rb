class CreatePdmRevisions < ActiveRecord::Migration
  def self.up
    create_table :pdm_revisions do |t|
      t.column :commit_message, :string
      t.column :attachment, :string
      t.column :created_by, :string
      t.column :created_date, :datetime
      t.column :document_type, :string
      t.column :pdm_document_id, :int
      t.column :pdm_attachment_id, :int   	  
    end
  end

  def self.down
    drop_table :pdm_revisions
  end
end
