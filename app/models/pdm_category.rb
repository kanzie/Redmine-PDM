class PdmCategory < ActiveRecord::Base
	    
	    #   This means that the category table is linked to many documents, as in that a category can have many documents in it
	has_many :pdm_documents

end
