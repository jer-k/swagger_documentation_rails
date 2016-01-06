== README

This repo is an example of how to set up Swagger documentation and a test to validate your specification against JSON Schema

* Install Swagger-UI
```ruby
npm install
node_modules/.bin/bower install
bundle exec rake swagger:create
```

* Test Swagger Specification
```ruby
bundle exec rspec spec/requests/swagger_spec.rb 
```

* View Swagger-UI
```ruby
bundle exec rails s
```
Browse to http://localhost:3000/internal/swagger-ui/index.html and enjoy!

