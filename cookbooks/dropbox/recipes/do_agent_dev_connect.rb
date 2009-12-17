# rs_agent_dev:cookbooks_path=/root/my_cookbooks/cookbooks,/root/premium/cookbooks,/root/public/cookbooks,/root/opscode

COOKBOOKS_PATH = "/root/my_cookbooks/cookbooks,/root/premium/cookbooks,/root/public/cookbooks,/root/opscode"
COOKBOOKS_TAG = "rs_agent_dev:cookbooks_path=#{COOKBOOKS_PATH}"

# Tell RightLink where to find your development cookbooks
right_link_tag COOKBOOKS_TAG

