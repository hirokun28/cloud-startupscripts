require 'spec_helper'

services = %w(httpd mariadb)
processes = %w(httpd mysqld)
ports = %w(80 3306)
logchk = 'ls /root/.sacloud-api/notes/[0-9]*.done'

if os[:family] == 'redhat' and os[:release] =~ /^6/
  services = %w(httpd mysqld)
end

if os[:family] == 'ubuntu'
  services = %w(apache2 mysql)
  processes = %w(apache2 mysqld)
end

services.each do |service_name|
  describe service(service_name) do
    it { should be_enabled }
    it { should be_running }
  end
end

processes.each do |proc_name|
  describe process(proc_name) do
    it { should be_running }
  end
end

ports.each do |port_number|
  describe port(port_number) do
    it { should be_listening }
  end
end

describe command(logchk) do
  its(:stdout) { should match /done$/ }
end
