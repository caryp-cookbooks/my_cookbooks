require 'rubygems'
require 'rest_connection'
require File.dirname(__FILE__) + '/lib/deployment_monk'
require 'highline/import'
require 'yaml'
require 'ruby-debug'

class History
  HISTORY_FILE = "history.yaml"
  attr_accessor :deployment_sets
  attr_accessor :template_sets
  def initialize
    @deployment_sets = []
    @template_sets = []
  end

  def self.load
    if File.exists?(HISTORY_FILE)
      YAML::load(IO.read(HISTORY_FILE))
    else
      new
    end
  end

  def save
    File.open(HISTORY_FILE,"w") do |f|
      f.write(self.to_yaml)
    end
  end
end

def do_templates_menu(my_history)
  templates = choose do |menu|
    new_layout = "1) New"
    my_history.template_sets.each_with_index do |ts,index|
      new_layout += "\n#{index+2})"
      ts.each do |t|
        st = ServerTemplate.find(t.to_i)
        new_layout += "\n   #{st.nickname}"
        new_layout += " rev[#{st.version}]" unless st.is_head_version
      end
    end
    new_layout += "\nWhat templates to use for generation? "
    menu.layout = new_layout
    menu.index = :number
    menu.choice("New")
    my_history.template_sets.each do |ts|
      menu.choice(ts)
    end
  end

  if templates == "New"
    templates = ask("what template ids? (comma separated list)", lambda { |str| str.split(/,\s*/) })
    my_history.template_sets << templates
  end

  templates
end

my_history = History.load

mode = choose do |menu|
  menu.header = "Deployment Sets Menu"
  menu.index = :number
  menu.choice "Create"
  menu.choice "Load"
  menu.choice "Destroy"
end

if mode == "Create"
    deployments_tag = ask("Enter new deployments_tag:")
    templates = do_templates_menu(my_history)
    dm = DeploymentMonk.new(deployments_tag,templates)
elsif %w{Load Destroy}.include? mode
  deployments_tag = choose do |menu|
    menu.index = :number
    menu.header = "What substring would you like to match deployments with?"
    my_history.deployment_sets.each {|d| menu.choice(d)}
    menu.choice("New")
  end
  deployments_tag = ask("Enter new deployments_tag:") if deployments_tag == "New"
  dm = DeploymentMonk.new(deployments_tag)
end

if mode == "Destroy"
  confirm = ask("Really destroy all these deployments? #{(dm.variations.map &:nickname).join(',')}", lambda { |ans| true if (ans =~ /^[y,Y]{1}/) })
  dm.destroy_all if confirm
end

if %w{Load Create}.include?(mode)
  gen = ask("Generate Deployment Set?", lambda { |ans| true if (ans =~ /^[y,Y]{1}/) })
  dm.generate_variations if gen
end

command = choose do |menu|
  menu.index = :number
  menu.choices(*dm.variations.map {|m| "#{m.nickname} | #{m.href} | #{m.servers.first.settings['ec2-image-href']}" })
end

go = ask("Save History OK?", lambda { |ans| true if (ans =~ /^[y,Y]{1}/) })
my_history.save if go
