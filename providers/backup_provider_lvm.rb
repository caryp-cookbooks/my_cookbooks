#
# Copyright (c) 2009 RightScale Inc
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require "rubygems"
require "right_aws"

class Chef
  class Provider
    class Backup
      class LVMROS < Chef::Provider
        
        @compress_opt = true
        @parallelism = 3

        def load_current_resource
          true
        end

        def action_prepare_backup
          # create snapshot to dir X
          snapshot_name = @new_resource.backup_lineage
          lvm = RightScaleHelper::LVM.new(@new_resource.mount_point)
          lvm.create_lvm_snapshot(nil, snapshot_name)
          true
        end
        
        def action_backup
          ros = ObjectRegistry.lookup(@node, @new_resource.backup_resource_name)
          raise "ERROR: Remote object store #{@new_resource.backup_resource_name} not found!"
          
          backup_mounted_on = @new_resource.backup_lineage              
          lvm = RightScaleHelper::LVM.new(@new_resource.mount_point)
          file_list = lvm.get_filelist_from_snapshot(backup_mounted_on, @new_resource.data_dir, @new_resource.file_list)

          file_list_filename = "/tmp/lvm_backup_file_list"      
          puts "Backup tree:"
          File.open(file_list_filename, File::WRONLY|File::TRUNC|File::CREAT, 0660) do |file|
            file_list.each do |fname|
              file.puts fname
              puts "#{fname}"
            end
          end
          
          # do upload
          user = ros.user
          key = ros.key
          type = ros.provider_type
          container = ros.container
          lineage = @new_resource.lineage
          ros_param = (type == "S3") : "--cloud ec2" ? "--cloud rackspace"
          
          datadir_canonicalized = lvm.get_datadir_canonicalized(@new_resource.data_dir)
          backup_root = "/#{backup_mounted_on}/#{datadir_canonicalized}".gsub(/\/\//,"/")
          puts "Rooting tar at: #{backup_root}"
          compress_flag = (@compress_opt ? "z":"") #Add the compression flag if specified
          tar_cmd = "cd #{backup_root}; nice tar c#{compress_flag}f - --files-from #{file_list_filename}"
          splitter_cmd = "/opt/rightscale/db/ec2_s3/mc_stream_helper.rb #{ros_param} --upload -b #{container} -f #{lineage} -p #{@parallelism}" 
          if (type == "S3")
            remote_env_cmd = "export AWS_ACCESS_KEY_ID='#{user}'; export AWS_SECRET_ACCESS_KEY='#{key}'"
          else
            remote_env_cmd = "export RACKSPACE_USER='#{user}'; export RACKSPACE_SECRET='#{key}'"
          end
          
          full_cmd = remote_env_cmd << " ; " << tar_cmd << " | " << splitter_cmd
                    
          puts "EXEC CMD: #{full_cmd}"
          result = `#{full_cmd}`
          raise "Returned: "+result if $? != 0   
        
          true
        end
        
        def action_cleanup_backup
          snapshot_name = @new_resource.backup_lineage
          lvm = RightScaleHelper::LVM.new(@new_resource.mount_point)          
          lvm.delete_snapshot(nil, snapshot_name)
        end
        
        def action_restore
          ros = ObjectRegistry.lookup(@node, @new_resource.backup_resource_name)
          raise "ERROR: Remote object store #{@new_resource.backup_resource_name} not found!"
          
          # do upload
          user = ros.user
          key = ros.key
          type = ros.provider_type
          container = ros.container
          lineage = @new_resource.lineage
          ros_param = (type == "S3") : "--cloud ec2" ? "--cloud rackspace"
  
          gzip_flag = "z" if lineage =~ /\.tgz$|\.gz$/ # We will recognize tar and gz extensions (otherwise we'll assume it's a plain tar)
          tar_cmd = "tar x#{gzip_flag}fC - #{@new_resource.mount_point}"
          if (type == "S3")
            remote_env_cmd = "export AWS_ACCESS_KEY_ID='#{user}'; export AWS_SECRET_ACCESS_KEY='#{key}'"
          else
            remote_env_cmd = "export RACKSPACE_USER='#{user}'; export RACKSPACE_SECRET='#{key}'"
          end
          splitter_cmd = "/opt/rightscale/db/ec2_s3/mc_stream_helper.rb #{ros_param} --download -b #{container} -k #{lineage}"
          return_value = "(( excode = $(echo ${PIPESTATUS[*]} | sed 's/0//;s/ //g') == 0 ? 0:-1 )) ; exit $excode"
  
          full_cmd = remote_env_cmd << " ; " << splitter_cmd << " | " << tar_cmd << " ; " << return_value
          STDERR.write("FULL CMD: #{full_cmd}")
          system("#{prefix} #{full_cmd}")
          raise "Error restoring backup. Returned:#{$?}\n") if $? != 0
        end
                
      end
    end
  end
end

