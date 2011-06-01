class PdmDocumentUploadFormController < ApplicationController
  unloadable


	def index
		@project = Project.find(params[:project_id])
		@documents = PdmDocument.all
	end


	def upload
		@project = Project.find(params[:project_id])
		redirect_to :action => 'index', :project_id => @project
	end

end
