# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

post 'favorites/create/:project_id', :to => 'favorite_projects#create'
delete 'favorites/delete/:id', :to => 'favorite_projects#destroy'