class CreatePdmAttachments < ActiveRecord::Migration
  def self.up
    create_table :pdm_attachments do |t|
      t.column :container_id, :int
      t.column :container_type, :string
      t.column :filename, :string
      t.column :disk_filename, :string
      t.column :filesize, :int
      t.column :content_type, :string
      t.column :downloads, :int
      t.column :author_id, :int  
      t.column :created_on, :datetime   	  
    end
  end

  def self.down
    drop_table :pdm_attachments
  end
end
