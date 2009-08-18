set_unless[:db_mysql][:tunable][:thread_cache_size] = 50
set_unless[:db_mysql][:tunable][:max_connections]     = "800" 
set_unless[:db_mysql][:tunable][:net_read_timeout]    = "30" 
set_unless[:db_mysql][:tunable][:net_write_timeout]   = "30" 
set_unless[:db_mysql][:tunable][:back_log]            = "128" 
set_unless[:db_mysql][:tunable][:max_heap_table_size] = "32M" 

if !ec2 
  set_unless[:db_mysql][:init_timeout] = 1200
  
  # using the same settings as a dedicated-m1.small ec2 instance
  set_unless[:db_mysql][:tunable][:key_buffer] = "128M"
  set_unless[:db_mysql][:tunable][:table_cache] = "256"
  set_unless[:db_mysql][:tunable][:sort_buffer_size] = "1M"
  set_unless[:db_mysql][:tunable][:net_buffer_length] = "8K"     
  set_unless[:db_mysql][:tunable][:read_buffer_size] = "1M"
  set_unless[:db_mysql][:tunable][:read_rnd_buffer_size] = "4M"
  set_unless[:db_mysql][:tunable][:myisam_sort_buffer_size] = "64M"
  set_unless[:db_mysql][:tunable][:query_cache_size] = "24M"
  set_unless[:db_mysql][:tunable][:innodb_buffer_pool_size] = "1G"
  set_unless[:db_mysql][:tunable][:innodb_additional_mem_pool_size] = "24M"
  set_unless[:db_mysql][:tunable][:log_slow_queries] = "log_slow_queries = /var/log/mysqlslow.log"
  set_unless[:db_mysql][:tunable][:long_query_time] = "long_query_time = 5"
  set_unless[:db_mysql][:tunable][:isamchk][:key_buffer] = "128M"
  set_unless[:db_mysql][:tunable][:isamchk][:sort_buffer_size] = "128M"
  set_unless[:db_mysql][:tunable][:myisamchk][:key_buffer] = "128M"
  set_unless[:db_mysql][:tunable][:myisamchk][:sort_buffer_size] = "128M" 
else
        
  # Override the init timeout value for EC2 instance types
  case ec2[:instance_type]
  when "m1.small"
     set_unless[:db_mysql][:init_timeout] = 600     
  when "c1.medium"
     set_unless[:db_mysql][:init_timeout] = 1200
  when "m1.large"
     set_unless[:db_mysql][:init_timeout] = 1800
  when "c1.xlarge"
     set_unless[:db_mysql][:init_timeout] = 1800
  when "m1.xlarge"
     set_unless[:db_mysql][:init_timeout] = 1800
  else 
     set_unless[:db_mysql][:init_timeout] = 1200
  end
  
  # tune the database for dedicated vs. shared and instance type
  case ec2[:instance_type]
  when "m1.small", "c1.medium" 
     if (db_mysql[:server_usage] == :dedicated) 
      set_unless[:db_mysql][:tunable][:key_buffer] = "128M"
      set_unless[:db_mysql][:tunable][:table_cache] = "256"
      set_unless[:db_mysql][:tunable][:sort_buffer_size] = "1M"
      set_unless[:db_mysql][:tunable][:net_buffer_length] = "8K"     
      set_unless[:db_mysql][:tunable][:read_buffer_size] = "1M"
      set_unless[:db_mysql][:tunable][:read_rnd_buffer_size] = "4M"
      set_unless[:db_mysql][:tunable][:myisam_sort_buffer_size] = "64M"
      set_unless[:db_mysql][:tunable][:query_cache_size] = "24M"
      set_unless[:db_mysql][:tunable][:innodb_buffer_pool_size] = "1G"
      set_unless[:db_mysql][:tunable][:innodb_additional_mem_pool_size] = "24M"
      set_unless[:db_mysql][:tunable][:log_slow_queries] = "log_slow_queries = /var/log/mysqlslow.log"
      set_unless[:db_mysql][:tunable][:long_query_time] = "long_query_time = 5"
      set_unless[:db_mysql][:tunable][:isamchk][:key_buffer] = "128M"
      set_unless[:db_mysql][:tunable][:isamchk][:sort_buffer_size] = "128M"
      set_unless[:db_mysql][:tunable][:myisamchk][:key_buffer] = "128M"
      set_unless[:db_mysql][:tunable][:myisamchk][:sort_buffer_size] = "128M"
     else
      set_unless[:db_mysql][:tunable][:key_buffer] = "64M"
      set_unless[:db_mysql][:tunable][:table_cache] = "64"
      set_unless[:db_mysql][:tunable][:sort_buffer_size] = "512K"
      set_unless[:db_mysql][:tunable][:net_buffer_length] = "8K"     
      set_unless[:db_mysql][:tunable][:read_buffer_size] = "512K"
      set_unless[:db_mysql][:tunable][:read_rnd_buffer_size] = "1M"
      set_unless[:db_mysql][:tunable][:myisam_sort_buffer_size] = "8M"
      set_unless[:db_mysql][:tunable][:query_cache_size] = "4M"
      set_unless[:db_mysql][:tunable][:innodb_buffer_pool_size] = "16M"
      set_unless[:db_mysql][:tunable][:innodb_additional_mem_pool_size] = "2M"
      set_unless[:db_mysql][:tunable][:log_slow_queries] = ""
      set_unless[:db_mysql][:tunable][:long_query_time] = ""
      set_unless[:db_mysql][:tunable][:isamchk][:key_buffer] = "20M"
      set_unless[:db_mysql][:tunable][:isamchk][:sort_buffer_size] = "20M"
      set_unless[:db_mysql][:tunable][:myisamchk][:key_buffer] = "20M"
      set_unless[:db_mysql][:tunable][:myisamchk][:sort_buffer_size] = "20M"
     end
  when "m1.large", "c1.xlarge"    
     if (db_mysql[:server_usage] == :dedicated) 
      set_unless[:db_mysql][:tunable][:key_buffer] = "192M"
      set_unless[:db_mysql][:tunable][:table_cache] = "512"
      set_unless[:db_mysql][:tunable][:sort_buffer_size] = "4M"
      set_unless[:db_mysql][:tunable][:net_buffer_length] = "16K"
      set_unless[:db_mysql][:tunable][:read_buffer_size] = "1M"
      set_unless[:db_mysql][:tunable][:read_rnd_buffer_size] = "4M"
      set_unless[:db_mysql][:tunable][:myisam_sort_buffer_size] = "64M"
      set_unless[:db_mysql][:tunable][:query_cache_size] = "32M"
      set_unless[:db_mysql][:tunable][:innodb_buffer_pool_size] = "4500M"
      set_unless[:db_mysql][:tunable][:innodb_additional_mem_pool_size] = "200M"
      set_unless[:db_mysql][:tunable][:log_slow_queries] = "log_slow_queries = /var/log/mysqlslow.log"
      set_unless[:db_mysql][:tunable][:long_query_time] = "long_query_time = 5"
      set_unless[:db_mysql][:tunable][:isamchk][:key_buffer] = "128M"
      set_unless[:db_mysql][:tunable][:isamchk][:sort_buffer_size] = "128M"
      set_unless[:db_mysql][:tunable][:myisamchk][:key_buffer] = "128M"
      set_unless[:db_mysql][:tunable][:myisamchk][:sort_buffer_size] = "128M"
     else
      set_unless[:db_mysql][:tunable][:key_buffer] = "128M"
      set_unless[:db_mysql][:tunable][:table_cache] = "256"
      set_unless[:db_mysql][:tunable][:sort_buffer_size] = "2M"
      set_unless[:db_mysql][:tunable][:net_buffer_length] = "8K"
      set_unless[:db_mysql][:tunable][:read_buffer_size] = "256K"
      set_unless[:db_mysql][:tunable][:read_rnd_buffer_size] = "512K"
      set_unless[:db_mysql][:tunable][:myisam_sort_buffer_size] = "8M"
      set_unless[:db_mysql][:tunable][:query_cache_size] = "24M"
      set_unless[:db_mysql][:tunable][:innodb_buffer_pool_size] = "2G"
      set_unless[:db_mysql][:tunable][:innodb_additional_mem_pool_size] = "100M"
      set_unless[:db_mysql][:tunable][:log_slow_queries] = ""
      set_unless[:db_mysql][:tunable][:long_query_time] = ""
      set_unless[:db_mysql][:tunable][:isamchk][:key_buffer] = "20M"
      set_unless[:db_mysql][:tunable][:isamchk][:sort_buffer_size] = "20M"
      set_unless[:db_mysql][:tunable][:myisamchk][:key_buffer] = "20M"
      set_unless[:db_mysql][:tunable][:myisamchk][:sort_buffer_size] = "20M"
     end 
  when "m1.xlarge"
     if (db_mysql[:server_usage] == :dedicated) 
      set_unless[:db_mysql][:tunable][:key_buffer] = "265M"
      set_unless[:db_mysql][:tunable][:table_cache] = "1024"
      set_unless[:db_mysql][:tunable][:sort_buffer_size] = "8M"
      set_unless[:db_mysql][:tunable][:net_buffer_length] = "16K"
      set_unless[:db_mysql][:tunable][:read_buffer_size] = "1M"
      set_unless[:db_mysql][:tunable][:read_rnd_buffer_size] = "4M"
      set_unless[:db_mysql][:tunable][:myisam_sort_buffer_size] = "96M"
      set_unless[:db_mysql][:tunable][:query_cache_size] = "64M"
      set_unless[:db_mysql][:tunable][:innodb_buffer_pool_size] = "900M"
      set_unless[:db_mysql][:tunable][:innodb_additional_mem_pool_size] = "200M"
      set_unless[:db_mysql][:tunable][:log_slow_queries] = "log_slow_queries = /var/log/mysqlslow.log"
      set_unless[:db_mysql][:tunable][:long_query_time] = "long_query_time = 5"
      set_unless[:db_mysql][:tunable][:isamchk][:key_buffer] = "128M"
      set_unless[:db_mysql][:tunable][:isamchk][:sort_buffer_size] = "128M"
      set_unless[:db_mysql][:tunable][:myisamchk][:key_buffer] = "128M"
      set_unless[:db_mysql][:tunable][:myisamchk][:sort_buffer_size] = "128M"
     else
      set_unless[:db_mysql][:tunable][:key_buffer] = "192M"
      set_unless[:db_mysql][:tunable][:table_cache] = "512"
      set_unless[:db_mysql][:tunable][:sort_buffer_size] = "2M"
      set_unless[:db_mysql][:tunable][:net_buffer_length] = "8K"
      set_unless[:db_mysql][:tunable][:read_buffer_size] = "512K"
      set_unless[:db_mysql][:tunable][:read_rnd_buffer_size] = "512K"
      set_unless[:db_mysql][:tunable][:myisam_sort_buffer_size] = "8M"
      set_unless[:db_mysql][:tunable][:query_cache_size] = "32M"
      set_unless[:db_mysql][:tunable][:innodb_buffer_pool_size] = "4G"
      set_unless[:db_mysql][:tunable][:innodb_additional_mem_pool_size] = "100M"
      set_unless[:db_mysql][:tunable][:log_slow_queries] = ""
      set_unless[:db_mysql][:tunable][:long_query_time] = ""
      set_unless[:db_mysql][:tunable][:isamchk][:key_buffer] = "20M"
      set_unless[:db_mysql][:tunable][:isamchk][:sort_buffer_size] = "20M"
      set_unless[:db_mysql][:tunable][:myisamchk][:key_buffer] = "20M"
      set_unless[:db_mysql][:tunable][:myisamchk][:sort_buffer_size] = "20M"
     end
  end 
end 