ruby_block "check value" do
  block do
    expected = "recipe"
    actual = node[:state_test][:value]
    Chef::Log.info "state_test::check_value -- Expected: #{expected} Actual: #{actual}"
    error = "ERROR: the node state is not persisted correctly between runs."
    raise error unless expected == actual 
    Chef::Log.info "state_test::check_value -- PASS"
  end
end
