curl -o latest.dump `heroku pg:backups public-url -a tracker-wolf`
ps -ef | grep "rails" | awk '{print $2}' | xargs kill
rake db:drop
rake db:create
pg_restore --verbose --clean --no-acl --no-owner -h localhost -d tracker_development latest.dump
rake db:migrate
