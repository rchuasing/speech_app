# README

Requirements:

- pg_trgm extension

  - to install in ubuntu
    sudo apt install postgresql-contrib

- postgresql

Setup instructions:

- bundle install
- bundle exec rake db:create
- bundle exec rake db:migrate

To generate swagger docs:

- bundle exec rake rswag:specs:swaggerize

* API documentation can be found in localhost:3000/api-docs after running the server
