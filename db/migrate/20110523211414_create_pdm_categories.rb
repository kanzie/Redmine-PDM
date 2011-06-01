class CreatePdmCategories < ActiveRecord::Migration

    def self.up
      create_table :pdm_categories do |t|
        t.column :name, :string
      end
      PdmCategory.create (:name => 'Uncategorized')
    end
  
    def self.down
      drop_table :pdm_categories
    end
    
    

end
