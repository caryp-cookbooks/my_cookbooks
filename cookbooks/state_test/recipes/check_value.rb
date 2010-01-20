ruby_block "check value" do
  block do
    expected = "recipe"
    actual = node[:state_test][:value]
    error = "ERROR: the node state is not persisted correctly between runs. Expected: #{expected} Actual: #{actual}"
    raise error unless expected == actual 
  end
end