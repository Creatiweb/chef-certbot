use_inline_resources

def whyrun_supported?
  true
end

action :create do

  live_dir = "#{node['certbot']['working_dir']}/live/#{new_resource.cn}"
  cert_command = "#{base_command} #{domains_arg} #{webroot_arg} #{renew_arg} #{server_arg} #{rsa_size_arg} --email #{node['certbot']['contact']} --agree-tos"

  execute 'certbot certonly' do
    command cert_command
  end

  directory node['certbot']['cert_dir'] do
    recursive true
  end

  link CertBot.certificate_dir(node['certbot']['cert_dir'], new_resource.cn) do
    to live_dir
  end
end

def server_arg
  "--server #{node['certbot']['endpoint']}/directory"
end

def renew_arg
  case new_resource.renew_policy
  when :renew_by_default then '--renew-by-default'
  when :keep_until_expiring then '--keep-until-expiring'
  end
end

def rsa_size_arg
  "--rsa-key-size #{new_resource.key_size}"
end

def webroot_arg
  "--webroot -w #{webroot_dir}"
end

def domains_arg
  cn = "-d #{new_resource.cn}"
  an = new_resource.alt_names.map { |fqdn| " -d #{fqdn}" }

  cn + an.join('')
end

def base_command
  "#{node['certbot']['executable']} certonly --non-interactive"
end

def webroot_dir
  new_resource.wwwroot
end

def well_known_dir
  "#{webroot_dir}/.well-known"
end
