rm tmp/pids/server.pid
rake db:migrate 
rake db:seed
rails server -b 0.0.0.0
