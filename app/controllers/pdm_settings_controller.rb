class PdmSettingsController < ApplicationController
  #unloadable
  #layout 'base'
  
  #before_filter :authorize
  @categories = PdmCategory.find(:all)	
  
  def index
	  @categories = PdmCategory.find(:all)	
  end
  
  def add_category
	category_name = params[:name]
	pdmcategory = PdmCategory.new(:name => category_name)
	pdmcategory.save
	redirect_to :action => 'index'
  end
  
end
