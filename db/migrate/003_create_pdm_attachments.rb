class CreatePdmAttachments < ActiveRecord::Migration
  def self.up
    create_table :pdm_attachments do |t|
      t.column :filename, :string
      t.column :disk_filename, :string
      t.column :filesize, :int
      t.column :content_type, :string
      t.column :downloads, :int
      t.column :author_id, :int  
      t.column :pdm_revision_id, :int	  
    end
  end

  def self.down
    drop_table :pdm_attachments
  end
end
