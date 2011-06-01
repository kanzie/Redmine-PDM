class CreatePdmDocuments < ActiveRecord::Migration
  def self.up
    create_table :pdm_documents do |t|
      t.column :description, :text
      t.column :locked_by, :int
      t.column :timestamp_expires, :datetime
      t.column :title, :string
      t.column :pdm_category_id, :int	
      t.column :archived, :int
    end
  end

  def self.down
    drop_table :pdm_documents
  end
end
