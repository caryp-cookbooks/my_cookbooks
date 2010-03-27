require 'dm-core'

sqlitedb = File.join(File.dirname(__FILE__), "..", "..", "features", "shared.db")
puts "using #{sqlitedb}"
DataMapper.setup(:default, "sqlite3:#{sqlitedb}")

class DeploymentSet
  include DataMapper::Resource
  property :id, Serial
  property :tag, String
end

class TemplateSet
  include DataMapper::Resource
  property :id, Serial
  has n, :templates
end

class Template
  include DataMapper::Resource
  property :unique_id, Serial
  property :id, Integer
  belongs_to :template_set  
end

class Job
  include DataMapper::Resource
  property :id, Serial
  property :pid, Integer
  property :status, String
  property :deployment_href, String
  has n, :log_files 
end

class LogFile
  include DataMapper::Resource
  property :id, Serial
  property :file, String
  belongs_to :job
end

