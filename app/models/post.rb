require 'camel_json'

class Post < ActiveRecord::Base
  include CamelJson
end