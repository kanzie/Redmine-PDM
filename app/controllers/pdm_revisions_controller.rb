require 'time'

class PdmRevisionsController < ApplicationController
	    #   The global variable for the lock time
	$timelock = 24.hours
	$extend_time = 12.hours
	before_filter :find_project, :authorize
	cattr_accessor :storage_path
    @@storage_path = ENV['RAILS_VAR'] ? File.join(ENV['RAILS_VAR'], '/files/') : "#{RAILS_ROOT}/files/"
	
	
	    #   This is the index view for the revisions. It finds all revisions and sorts them after the date
	    #   they were created so the latest appears at top.
	    #   It also checks the Time lock to see if there is any time remaining on a locked document  
    def index
        @document = PdmDocument.find(params[:id])
        @revisions = PdmRevision.find(:all, :order => "created_date DESC", :conditions => [ "pdm_document_id = ?", @document.id ] )
        checkTimelock
    end


        #   This simply finds the id for the project and is called initially in the controller
	def find_project
		@project = Project.find(params[:project_id])
	end
	
	    #   The extend_timelock function adds 12 hours to the already existing timelock to the specific ID.
	def extend_timelock
		@project = Project.find(params[:project_id])
        @document = PdmDocument.find(params[:id])
	    new_timelock = 12.hours
	    
	    @document.update_attributes(:locked_by => User.current.id, :timestamp_expires => @document.timestamp_expires + new_timelock)
		@document.save
        redirect_to :action => 'index', :project_id => @project, :id => @document
    end
	
	
	    #   If a document is locked, checkTimelock calculates how much time is missing and calls changeLock to
	    #   remove the lock if the time is out
    def checkTimelock
        timelock = 24.hours
        @document = PdmDocument.find(params[:id])
        if(@document.timestamp_expires != nil)
            distance = @document.timestamp_expires - Time.now
            
            
            if(distance < 1.seconds)
                lock_time_out
            end
        end
    end
    
    
        #   The function <tt>lock_time_out</tt> is called from within the checkTimeLock function. 
        #   It sets the timestamp_expires to nil (nothing).
    def lock_time_out
        @document = PdmDocument.find(params[:id])
        @document.update_attributes(:locked_by => nil, :timestamp_expires => nil)
        redirect_to :action => 'index', :project_id => @project, :id => @document
    end

    
    
        #   The download function takes parameters for which document and which revisions that document has,
        #   and then lets the user download the file
    def download
        @revision = PdmRevision.find(params[:id])
        @document = PdmDocument.find(:first, :conditions => [ "id = ?",@revision.pdm_document_id ] )
        revisionName = @revision.attachment
        trash, newFileName = revisionName.split(/_/, 2)
        FileUtils.copy(@@storage_path + revisionName, @@storage_path + newFileName)
        send_file (@@storage_path + newFileName, :stream => false)
        File.delete(@@storage_path + newFileName)
    end
  
  
  
        #   The downloadLatest function sends parameters to the download function to tell it that the revision to
        #   be downloaded is the latest, by finding the revision that was added the latest to that particular document
    def downloadLatest
        @document = PdmDocument.find(params[:id])
        @revision = PdmRevision.find(:first, :order => "created_date DESC", :conditions => [ "pdm_document_id = ?", @document.id ] )
    
        redirect_to :action => 'download', :project_id => @project, :id => @revision
    
    end
    
    
    
        #   The uploadNewRevision function takes the parameters given in the revisions index view and stores them in
        #   a new entry in the database. If now parameters are taken, it changes so that a locked file becomes unlocked
        #   without doing anything else.
    def uploadNewRevision	
        @document = PdmDocument.find(params[:id])
        upload = params[:upload]
  	    comment = params[:comment]	
  	
	    if User.current.id == @document.locked_by
		    @document.update_attributes(:locked_by => nil, :timestamp_expires => nil)
		    @document.save
        
        #   Validation check
  	        if upload != nil && !comment.empty?
    	        fileTime = Time.new.to_f
    		    documentName = upload['datafile'].original_filename
    		    fileName = (fileTime).to_s + "_" + documentName
        	
        	    directory = @@storage_path
        	    path = File.join(directory, fileName)

			    File.open(path, "wb") do |f| 
				buffer = ""
				while (buffer = upload['datafile'].read(8192))
					f.write(buffer)
				end
			end
  	        #   Adds a new entry in the database table for Revisions with the parameters below
  	        #   because every initial commit in a document is the first revision
  	        pdmrevision = PdmRevision.new(:commit_message => params[:comment], :attachment => fileName, :created_by => User.find(User.current.id), :created_date => Time.now, :pdm_document_id => params[:id])
            pdmrevision.save
  	        redirect_to :action => 'index', :project_id => @project, :id => @document
		else
		    @document.update_attributes(:locked_by => nil, :timestamp_expires => nil)
			redirect_to :action => 'index', :project_id => @project, :id => @document			
		end			
	end
	
	end
	
  
        #   The changeLock function changes a document from being locked to unlocked based on current state
    def changeLock
	    @project = Project.find(params[:project_id])
        @document = PdmDocument.find(params[:id])
		
	    if @document.locked_by == nil	    
		    @document.update_attributes(:locked_by => User.current.id, :timestamp_expires => Time.now + $timelock)
		    @document.save
		
		#   This checks to see if the current user is the one that has locked the document, or if the user has
		#   super settings such as admin or manager, for example and can remove a lock
	    elsif User.current.id == @document.locked_by or User.current.allowed_to?(:settings, @project)
		    @document.update_attributes(:locked_by => nil, :timestamp_expires => nil)
	    end
            redirect_to :action => 'index', :project_id => @project, :id => @document
   	
    end

end
