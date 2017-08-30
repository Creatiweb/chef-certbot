include_recipe 'letsencrypt-boulder-server'

hostsfile_entry '127.0.0.1' do
  hostname  'www.example.com'
  aliases   ['example.com']
  comment   'Append by acme_server'
  action    :append
end
