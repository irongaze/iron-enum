
Gem::Specification.new do |s|
  # Project attributes
  s.name        = "iron-enum"
  s.summary     = "Enum support for Ruby and Rails"
  s.description = "Adds enumerated constant value support to Ruby and Rails projects"

  # Include all gem files that should be packaged
  s.files = Dir[
    "lib/**/*", 
    "bin/*", 
    "spec/**/*", 
    "LICENSE", 
    "*.txt",
    "*.rdoc",
    ".rspec"
  ]
  # Prune out files we don't want to include
  s.files.reject! do |p| 
    ['.tmproj'].detect {|test| p.include?(test)}
  end
  
  # Meta-info
  s.version     = File.read('version.txt').strip
  s.authors     = ["Rob Morris"]
  s.email       = ["rob@irongaze.com"]
  s.homepage    = "http://irongaze.com"
  
  # Boilerplate
  s.platform    = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.executables = Dir["bin/*"].collect {|p| File.basename(p)}
  s.add_development_dependency "rspec", "~> 2.6"
  s.add_development_dependency "active_record", "~> 3.0"
  s.add_development_dependency "sqlite3", "~> 1.3"
  s.required_ruby_version = '>= 1.9.2'
  s.license     = 'MIT'
end