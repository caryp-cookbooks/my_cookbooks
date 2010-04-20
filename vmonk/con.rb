require 'rubygems'
require 'rest_connection'
require  File.join(File.dirname(__FILE__), 'lib', 'deployment_monk')
require 'highline/import'
require 'yaml'
require 'fileutils'
require 'ruby-debug'
require File.join(File.dirname(__FILE__), "lib", "storage")
require File.join(File.dirname(__FILE__), "lib", "cuke_monk")

class MenuMonk
  FEATURE_GLOB = File.join(File.dirname(__FILE__), "..", "**", "*.feature")
  CONFIG_DIR=File.join(File.dirname(__FILE__), "config")

  def do_templates_menu
    choose do |menu|
      new_layout = "Templates Menu>\n1) New"
      TemplateSet.all.each_with_index do |ts,index|
        new_layout += "\n#{index+2})"
        ts.templates.each do |t|
          st = ServerTemplate.find(t.id)
          new_layout += "\n   #{st.nickname}"
          new_layout += " rev[#{st.version}]" unless st.is_head_version
        end
      end
      new_layout += "\nPick a set of templates -or- New:"
      menu.layout = new_layout
      menu.index = :number
      menu.choice("New") do
        ask("what template ids? (comma separated list)",
          lambda { |str| 
            new_ts = TemplateSet.create
            str.split(/,\s*/).each do |t|
              Template.create(:id => t.to_i, :template_set => new_ts)
            end
            new_ts
          })
      end
      TemplateSet.all.each do |ts|
        menu.choice(ts)
      end
    end
  end

  def initialize
    choose do |menu|
      menu.header = "Deployment Sets Menu"
      menu.index = :number
      menu.choice "Create" do
        deployments_tag = ask("Enter new deployments_tag:")
        templateset = do_templates_menu
        DeploymentSet.create(:tag => deployments_tag)
        @dm = DeploymentMonk.new(deployments_tag, templateset.templates.map(&:id))
      end
      menu.choice "Load" do
        deployments_tag = choose do |menu|
          menu.index = :number
          menu.header = "What substring would you like to match deployments with?"
          DeploymentSet.all.each {|d| menu.choice(d.tag)}
          menu.choice("New") do
            deployments_tag = ask("Enter new deployments_tag:") 
            DeploymentSet.create(:tag => deployments_tag)
            deployments_tag
          end
        end
        @dm = DeploymentMonk.new(deployments_tag)
      end
    end
  end

  def load_common_inputs()
    loadables = Dir.glob(File.join(CONFIG_DIR, "**/*.json"))
    load_this = choose do |menu|
      menu.header = "Load deployment inputs from file:"
      menu.choices(*loadables)
      menu.choice("next") {return}
    end
    @dm.load_common_inputs(load_this)
  end

  def release_dns(tag=nil)
# does this messup datamapper?
    require 'sqlite3'
    SQLite3::Database.new(File.join(File.dirname(__FILE__), "..", "features", "shared.db")) do |db|
      if tag
        q = db.query("UPDATE mysql_dns SET owner=NULL where owner LIKE '#{tag}%'")
      else
        q = db.query("UPDATE mysql_dns SET owner=NULL")
      end
      q.close
      db.query("SELECT * FROM mysql_dns") do |result|
        puts result.entries
      end
    end
  end

## MAIN MENU
  def main()
    while(1)
      choose do |menu|
        menu.header = "Main Menu> #{@dm.tag}"
        menu.index = :number
        menu.choice("generate more") {@dm.generate_variations}
        menu.choice("load common inputs") { load_common_inputs() }
        menu.choice("RELEASE ALL dns") do
          release_dns
        end
        menu.choice("RELEASE dns") do
          release_dns(@dm.tag)
        end
        menu.choice("DESTROY all") do
          confirm = ask("Really destroy all these deployments? #{(@dm.variations.map &:nickname).join(',')}", lambda { |ans| true if (ans =~ /^[y,Y]{1}/) })
          @dm.destroy_all if confirm
        end 
        menu.choice("run cuke feature on all deployments") { run_cuke }
        menu.choices(*@dm.variations.map {|m| "#{m.href}" }) do |dep_href|
          
          deployment_menu(dep_href)
        end
        menu.choice("quit") { exit(0) }
        menu.choice("refresh")
      end
    end
  end

  def run_cuke()
    loadables = Dir.glob(FEATURE_GLOB)
    feature_name = choose do |menu|
      menu.header = "Run Feature:"
      menu.choices(*loadables)
      menu.choice("cancel") {return}
    end
    FileUtils.mkdir_p("log")
    cm = CukeMonk.new
    ENV['REST_CONNECTION_LOG'] = "log/rest_connection.log"
    deployment_nicknames = @dm.variations.map &:nickname
    cm.run_tests(deployment_nicknames, feature_name)
    cm.generate_reports
  end

  def deployment_menu(deploy_href)
    deploy = Deployment.find(deploy_href)
    deploy.servers.each {|s| s.settings}
    pp deploy
    choose do |menu|
      menu.choice("start") { deploy.servers.each {|s| s.start} }
      menu.choice("stop") { deploy.servers.each {|s| s.stop} }
      menu.choice("reboot") { deploy.servers.each {|s| s.reboot} }
      menu.choice("release DNS") { release_dns(deploy.nickname) }
      #menu.choice("run cuke") {run_cuke(deploy)}
      menu.choice("back") 
    end
  end
end

m = MenuMonk.new
m.main

