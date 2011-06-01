class PdmDocumentsController < ApplicationController
	
	before_filter :find_project, :authorize, :only => :index
	cattr_accessor :storage_path
  	@@storage_path = ENV['RAILS_VAR'] ? File.join(ENV['RAILS_VAR'], 'files') : "#{RAILS_ROOT}/files/"	
	
	    #   This is the index that finds the project ID and all the documents in descending order based on ID, so the latest
	    #   appears on top.
	def index
		@project = Project.find(params[:project_id])
		@documents = PdmDocument.find(:all, :order => "id DESC", :include=>[:pdm_revisions, :pdm_category], :conditions => [ "archived = ?", 0 ])
		@categories = PdmCategory.find(:all)
	end
	
	def show
	
	end
	
	    #   The uploadFile function takes the parameters given in the upload form in the documents index view and adds them in a new
	    #   entry in the database.
	    #   It has validation control so that if no fields are filled, the user is prompted with a message stating to fill in all the fields	
	def uploadFile
		@project = Project.find(params[:project_id])
		
		upload = params[:upload]
		name = params[:title]
		if upload != nil && !name.empty?
			documentName = upload['datafile'].original_filename
			documentName = documentName.gsub(/[^\w\.\-]/,'_')
			fileTime = Time.new.to_f
			directory = "#{@@storage_path}"
			fileName = (fileTime).to_s + "_" + documentName
			path = File.join(directory, fileName)

			File.open(path, "wb") do |f| 
				buffer = ""
				while (buffer = upload['datafile'].read(8192))
					f.write(buffer)
				end
			end
			
			category_id = params[:name][:id]
		
			#   By performing hashed input like below rails automatically prevents sql-injections      
			pdmdocument = PdmDocument.new(:title => params[:title], :description => params[:comment], :last_revision_by => User.current.id, :pdm_category_id => category_id, :archived => 0)
			pdmdocument.save
		
			@document = pdmdocument
			#   Adds a row in the database table for revisions taking the parameters below 
			pdmrevision = PdmRevision.new(:commit_message => "Initial commit", :attachment => fileName, :created_by => User.current.id, :created_date => Time.now, :pdm_document_id => pdmdocument.id)
			pdmrevision.save
			redirect_to :action => 'index', :project_id => @project
		else
			redirect_to :action => 'index', :project_id => @project
			flash[:error] = l(:label_missing_param_file)
		end		
		
		
	end
	
	    #   The archive function does not actually delete a document, but rather changes the archive attribute in the database
	    #   so that it isn't shown in the documents table anymore. The file still exists in the database, but is archived.
	def archive
	  @project = Project.find(params[:project_id])
	  @document = PdmDocument.find(params[:id])
	  @document.update_attributes(:archived => 1)
    @document.save
	  redirect_to :controller => 'pdm_documents', :action => 'index', :project_id => @project
	  flash[:notice] = l(:label_archived_successful)
	end
	
	def find_project
		@project = Project.find(params[:project_id])
	end
end
