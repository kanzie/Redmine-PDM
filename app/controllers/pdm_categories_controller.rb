class PdmCategoriesController < ApplicationController

		
    #   The index finds all the categories in the database table with the same name
  def index	
	@categories = PdmCategory.find(:all)	
  end


    #   The add_category function adds a new category with the parameter taken from the index view field
    #   as the new category name. It is stored in the database.
  def add_category
	category_name = params[:name]

	pdmcategory = PdmCategory.new(:name => category_name)
	pdmcategory.save
	redirect_to :action => 'index'
  end

end
