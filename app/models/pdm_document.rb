class PdmDocument < ActiveRecord::Base
	
	    #   This means that the document has many revisions
	has_many :pdm_revisions
	
	    #   This means the document belongs to a category
	belongs_to :pdm_category
end
