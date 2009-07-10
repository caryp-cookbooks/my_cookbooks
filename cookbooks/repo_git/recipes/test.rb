#
# Cookbook Name:: repo_git
# Recipe:: default
#
# Copyright 2009, RightScale, Inc.
#

repo_git_pull "git-test" do
  url "ssh://git@github.com/ermal14/ermal14.git"
  user "ermal14"
  dest "/root/git_test"
  branch "rails_app"
  cred <<-EOH
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAz5ycjRe2w/hSqLfkT2rPs9CfCH2IV/C2mWx5vpHfdZUKzN3A
XJuFdn2TlkK48lkOHQVAlxH+VkIYXuOOz9xgJI/dileiaFmwAeTa0ImGV4O1/KOp
SuBH/4PMeV+MhTlkcqxbSBBOHVrDwNAk6pzvY+sFxTmOD4ifBNGYB5fjNXZJqno9
L+4VOIbFpgH1XJIrW8DA29i8E5iXrNN42wwDF1+AuSR3XSS+TwtsIjG5nO5q9PwG
CMNENrFXcCR7FFmZCCDF87y2KCSTqIlZYQGErPEAk4VGM7wwAw+tXjyoHu+59/bN
fJdLMKbyNhDLDrkTtF1xNAc+dUFIy6r/ETnEUwIBIwKCAQARy5hj3XYQzCRXmrvM
SvvcNnQICsKLMePEAfvOgYgupmAC7m+S6MJL/CKX2dVWmetEUOhHdpIkppRf556G
2GADIkYwbelZZsXxiKUKj3HqPn1QK0kGav7bYxGGvwwLa1HAr7ANfb2NfM7zRQp6
gnrrTqi5IjC/gL0sTHq+0oEwd7LnybFsitMQwDA8tnBT/d06UF4M7fQySx6DNwag
jdAgfzJum1kknPAb4irW/tyQuNCIXdbVYJ2+OB/RwQk4ifljuS+uVgv+qO9g2+7F
aOSxAkdLkpuFEBGi8lS+4RcYhd5V7VkL1bZV9rlN0cCFqE2BhyMZmApyEtEKX/yG
+mGjAoGBAOja+YAktkMS6fj7Xqoj/Qf0Z12yJoYlWcnanMaEMxaJ4bjgVnNtZxwB
VnrZ3bBcWh5YMezfkrr7oFpCVzzS2Yq4VWfjMiiYeFWeXk1x5DuzAT7T4d1ae1RT
v1Qfcq6kijifP7URrzZOpnLwjRtgNfov2isK3NRs29PLkt9avDYlAoGBAOQ/T6cY
5DO3hUSQ/YIPWLkUWm89hL+jfRSCCg+wYnBnsdDOZElElrEIZlLRYVFS0su7Lflv
yVjlLN9JVn1Yi7DEWtxz9AGfTqqgJSpFVYeTf9dN9P0eMA3s79HhMpaxoQoY5gmL
gBr3F2K5nz7sgjvysAH+kfAq30OHDZ2PvxsXAoGBAOIzzczwdopM40mjuwut7nzB
iPvu45hBimxQtY2k/m2qg4Bk5kQ+ZCnVafOvEd6FmV9OXGJyyQ1pdzMb37dtvWIv
aOiTj8+qDn8O30Pq+vgqO7lgHT1t1uQ0GPKiNOQqz2o0TIQCjPLtUTx0plUboiY9
HRPeqqJ4YISZ3yIdoOQjAoGAE5Bl6cBOEw+69z+gs2BmsMc685ePCRykUjcILTsB
H5PcCpVZDZgqLG5vK6uL/6gDcIxjBsBwWBOkwq6DwZngFnc6/PP++NMj//8ZIOFf
Gj/Xwf9eJFMLbuhsU9F5XV+ut7j9xk3JJuH6sLDTIqaO0fA6+NtOVmoTIwuTc+e/
7GECgYEAjQs4T5nN6Ic5ULfnZuXv3QjYwDmPB0z5p+/sbUmklofHAjQ29CGCObwD
IOZZEhBr7e4DQ+wFmGJ1jShDy1EOIo1wnHMyZ5SmMgegdM/hcc3hrIlnFY2FOMNm
5Z10ltBHfYO/leSZo3pL/GyxRs4P7/7rhwdfvoBmW9a/W3Qxoe4=
-----END RSA PRIVATE KEY-----
EOH
end
