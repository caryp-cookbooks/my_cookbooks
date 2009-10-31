
# install git client
case node[:platform]
when "debian", "ubuntu"
  package "git-core"
else 
  package "git"
end

package "gitk"
package "git-svn"
package "git-email"