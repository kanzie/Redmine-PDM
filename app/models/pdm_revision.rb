class PdmRevision < ActiveRecord::Base
        
        #   This means the revision has a file attachment
  has_one :pdm_attachment
        
        #   This means that revisions belong to a document  
	belongs_to :pdm_document

end
