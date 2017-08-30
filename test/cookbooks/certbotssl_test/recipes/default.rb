include_recipe 'apache2'
include_recipe 'apache2::mod_ssl'
include_recipe 'certbotssl::default'
include_recipe 'certbotssl::cron'

app_name = 'example.com'
app_root = ::File.join('/var/www/', app_name)
directory app_root do
  recursive true
end

certbotssl_selfsigned app_name do
  alt_names ['www.example.com']
end

web_app app_name do
  template 'web_app.conf.erb'
  server_port 80
  ssl_server_port 443
  server_name 'www.example.com'
  server_aliases ['example.com']
  docroot app_root
  crt ::File.join(node['certbot']['cert_dir'], app_name, 'cert.pem')
  chain ::File.join(node['certbot']['cert_dir'], app_name, 'chain.pem')
  key ::File.join(node['certbot']['cert_dir'], app_name, 'privkey.pem')
end

certbotssl_certificate app_name do
  wwwroot app_root
  alt_names ['www.example.com']
  notifies :reload, 'service[apache2]', :delayed
end
