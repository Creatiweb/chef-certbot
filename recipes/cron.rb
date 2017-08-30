cron_d 'letsencrypt' do
  minute node['certbot']['cron']['frequency']['minute']
  hour node['certbot']['cron']['frequency']['hour']
  day node['certbot']['cron']['frequency']['day']
  month node['certbot']['cron']['frequency']['month']
  weekday node['certbot']['cron']['frequency']['weekday']
  user 'root'
  command "#{node['certbot']['executable']} renew -q #{CertBot.hooks_args(node['certbot']['cron']['hooks'])}"
  action :create
end
