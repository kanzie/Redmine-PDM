ActionController::Routing::Routes.draw do |map|
  map.resources :pdm_documents
  map.resources :pdm_documents, :path_prefix => '/projects/:project_id'
  map.resources :pdm_revisions
  map.resources :pdm_revisions, :path_prefix => '/projects/:project_id'
end