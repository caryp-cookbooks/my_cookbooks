require 'rubygems'
require 'rest_connection'
require File.dirname(__FILE__) + '/lib/deployment_monk'
require 'ruby-debug'
# from MCI: 
extra_images = [ {"image_href" => "https://my.rightscale.com/api/acct/0/ec2_images/ami-0859bb61?cloud_id=1",
                "cloud_id" => 1,
                "aws_instance_type" => "m1.small" },
# MCI: 26495 5.1.1 Alpha i386 CentOS
                 { "cloud_id" => 1,
                   "image_href" => "https://my.rightscale.com/api/acct/0/ec2_images/ami-0859bb61?cloud_id=1",
                   "aws_instance_type" => "m1.small" },
# MCI: 26494 5.1.1 Alpha x86_64 Ubuntu
                 {"aws_instance_type"=> "m1.large",
                       "image_href"=> "https://my.rightscale.com/api/acct/0/ec2_images/ami-4af01223?cloud_id=1",
                       "cloud_id"=>1 },
                 {"aws_instance_type"=>"m1.large",
                       "image_href"=> "https://my.rightscale.com/api/acct/0/ec2_images/ami-3df8d349?cloud_id=2",
                       "cloud_id"=>2},
                 {"aws_instance_type"=>"m1.large",
                       "image_href"=> "https://my.rightscale.com/api/acct/0/ec2_images/ami-cf3d6c8a?cloud_id=3",
                       "cloud_id"=>3} 
                ]

require 'json'
File.open("config/mysql_5.0_extra_images.json", "w") {|f| f.write(extra_images.to_json)}
#dm = DeploymentMonk.new([27418,27418], extra_images)
#dm.generate_variations
#debugger
#puts 'blah'
