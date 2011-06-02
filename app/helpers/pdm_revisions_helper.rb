module PdmRevisionsHelper
  
    def link_to_attachment(attachment, options={})
    puts "I'm still alive"
    text = l(:link_revision_download)
    action = 'download'
    @project = Project.find(params[:project_id])
    puts "Project: " + @project.inspect
    puts "Attachment: " + attachment.inspect
    link_to(h(text), {:controller => 'pdm_attachments', :action => action, :id => attachment, :filename => attachment.filename, :project_id => @project.id}, options)
  end
  
end
