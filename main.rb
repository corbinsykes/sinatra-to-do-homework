require 'pry'
require 'sinatra'
require 'pg'
require 'sinatra/reloader' if development?


# List todo items
get '/' do
  db = PG.connect(:dbname => 'lists', :host => 'localhost')
  sql = "SELECT * FROM to_do"
  @todo = db.exec(sql)
  db.close

  erb :todos
end

# Show the details of a todo
get '/todo/:id' do
  id = params[:id]
  db = PG.connect(:dbname => 'lists', :host => 'localhost')
  sql = "SELECT * FROM to_do WHERE id = #{id}"
  @todo = db.exec(sql).first
  db.close

  erb :todo
end

# create todo
get '/create_todo' do
  erb :create_todo
end

# Create a todo by sending a POST request to this URL
post '/create_todo' do
  id = params[:id]
  task = params[:task]
  location = params[:location]
  description = params[:description]
  is_this_done = params[:is_this_done]

  db = PG.connect(:dbname => 'lists', :host => 'localhost')
  sql = "INSERT INTO to_do (task, location, description, is_this_done) VALUES ('#{task}', '#{location}', '#{description}', #{is_this_done})"
  db.exec(sql)
  db.close
  #This will send you to the newly created todo
  redirect to('/')
end

# Editing page
get '/todo/:id/edit' do
  id = params[:id]
  db = PG.connect(:dbname => 'lists', :host => 'localhost')
  sql = "SELECT * FROM to_do WHERE id = #{id}"
  @todo = db.exec(sql).first
  db.close

  erb :edit
end

# Actually editing the task
post '/todo/:id/edit' do
  id = params[:id]
  task = params[:task]
  location = params[:location]
  description = params[:description]
  is_this_done = params[:is_this_done]
  db = PG.connect(:dbname => 'lists', :host => 'localhost')
  sql = "UPDATE to_do SET (task, location, description, is_this_done) = ('#{task}', '#{location}', '#{description}', #{is_this_done}) WHERE id = '#{id}'"
  db.exec(sql).first
  db.close

  redirect to '/'
end

#Removing a task from the list
post '/todo/:id/delete' do
  id = params[:id]
  task = params[:task]
  location = params[:location]
  description = params[:description]
  is_this_done = params[:is_this_done]
  db = PG.connect(:dbname => 'lists', :host => 'localhost')
  sql = "DELETE FROM to_do WHERE id = '#{id}'"
  db.exec(sql).first
  db.close

  redirect to '/'
end