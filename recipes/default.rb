case node['platform_family']
when 'debian'
  if node['platform'] == 'ubuntu' && node['platform_version'].to_f >= 14.04
    apt_repository 'certbot' do
      uri 'ppa:certbot/certbot'
    end
    package 'certbot'
  elsif node['platform'] == 'debian' && node['platform_version'].to_f >= 8.0
    package 'certbot' do
      default_release 'jessie-backports' unless node['platform_version'].to_i != 8
      action :install
    end
  end
when 'rhel'
  if node['platform'] == 'centos' || node['platform'] == 'rhel' && node['platform_version'].to_f >= 7.0
    package 'epel-release'
    package 'certbot'
  end
end

directory node['certbot']['working_dir'] do
  owner 'root'
  group 'root'
  mode 0755
  recursive true
  action :create
end
