class PdmAttachmentsController < ApplicationController
  #before_filter :find_project

  #verify :method => :post
  
  def show
    if @pdm_attachment.is_diff?
      @diff = File.new(@pdm_attachment.diskfile, "rb").read
      render :action => 'diff'
    elsif @pdm_attachment.is_text?
      @content = File.new(@pdm_attachment.diskfile, "rb").read
      render :action => 'file'
    else
      download
    end
  end
  
  def download 
    @pdm_attachment = PdmAttachment.find(params[:id])
    
    send_file @pdm_attachment.diskfile, :filename => filename_for_content_disposition(@pdm_attachment.filename),
                                    :type => detect_content_type(@pdm_attachment)                                
  end
  
  def downloadLatest
    @document = PdmDocument.find(params[:id])
    @revision = PdmRevision.find(:first, :order => "created_date DESC", :include=> :pdm_attachment, :conditions => [ "pdm_document_id = ?", @document.id ] )
    @attachment = @revision.pdm_attachment
    redirect_to :action => 'download', :id => @attachment.id
  end
  
private
  def find_project
    @pdm_attachment = PdmAttachment.find(params[:id])
    # Show 404 if the filename in the url is wrong
    raise ActiveRecord::RecordNotFound if params[:filename] && params[:filename] != @pdm_attachment.filename
    @project = @pdm_attachment.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end
  
  def detect_content_type(pdm_attachment)
    content_type = pdm_attachment.content_type
    if content_type.blank?
      content_type = Redmine::MimeType.of(pdm_attachment.filename)
    end
    content_type.to_s
  end
end