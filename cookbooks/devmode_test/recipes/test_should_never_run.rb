
ruby_block "I fail" do
  block do
    raise "ERROR: If you intended to set a breakpoint -- it failed."
  end
end