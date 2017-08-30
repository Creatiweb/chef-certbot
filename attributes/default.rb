
default['certbot']['contact'] = ''
default['certbot']['endpoint'] = 'https://acme-v01.api.letsencrypt.org'
default['certbot']['key_size'] = 2048

default['certbot']['working_dir'] = '/etc/letsencrypt'
default['certbot']['cert_dir'] = "#{default['certbot']['working_dir']}/current"
default['certbot']['executable'] = '/usr/bin/certbot'

default['certbot']['cron']['frequency'] = {
  'minute' => '0',
  'hour' => '*/12',
  'day' => '*',
  'month' => '*',
  'weekday' => '*',
}
default['certbot']['cron']['hooks']['pre-hook'] = ''
default['certbot']['cron']['hooks']['post-hook'] = ''
default['certbot']['cron']['hooks']['renew-hook'] = ''
