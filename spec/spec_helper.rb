# Set up activerecord & in-memory SQLite DB
require 'active_record'
require 'sqlite3'
ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

# Run a migration to create our test table
ActiveRecord::Migration.create_table :ar_tests do |t|
  t.integer 'enum_field'
  t.integer 'another_enum'
end

# Require our library
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'iron', 'enum'))

# Config RSpec options
RSpec.configure do |config|
  config.add_formatter 'documentation'
  config.color = true
  config.backtrace_exclusion_patterns = [/rspec/]
end

