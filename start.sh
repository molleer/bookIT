( rake db:migrate && rake db:seed || (rake db:setup && rake db:seed && echo)) && \

rails server -b 0.0.0.0 -p 3001
