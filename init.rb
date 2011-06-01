# Redmine Purple Document Management plugin
# 
# Copyright 2011 Team purple <kanzie@gmail.com>
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301, USA.

require 'redmine'
RAILS_DEFAULT_LOGGER.info 'Starting Purple Document Management 1.0.0'

# Redmine Purple Document Management
Redmine::Plugin.register :redmine_pdm do
  name 'Redmine PDM plugin'
  author 'Team Purple'
  description 'Document revision control plugin for Redmine'
  version '0.5.9'
  url ''
  author_url ''
  
  # This plugin contains settings
  settings :default => {
    'Say hello to world?' => ''
  }, :partial => 'settings/pdm_settings'
  
  # This plugin adds a project module
  # It can be enabled/disabled at project level (Project settings -> Modules)    
  project_module :pdm do
    # This permission has to be explicitly given
    # It will be listed on the permissions screen  
	permission :read, {:pdm_documents => [:index, :show], :pdm_revisions => [:index, :download, :downloadLatest]} 
	permission :write, {:pdm_documents => [:uploadFile, :archive], :pdm_revisions => [:changeLock, :uploadNewRevision, :extend_timelock]}
	permission :settings, {:pdm_categories => [:add_category]}, :require => :member
  end

  # A new item is added to the project menu  
  menu :project_menu, :pdm, { :controller => 'pdm_documents', :action => 'index' }, :caption => 'PDM', :after => :documents, :param => :project_id
  menu :admin_menu, :pdm, { :controller => 'pdm_categories', :action => 'index' }, :caption => 'PDM Settings', :after => :settings, :before => :plugins, :param => :project_id
  
end
