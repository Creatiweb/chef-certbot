actions :create
default_action :create

property :cn, String, name_property: true
property :alt_names, Array, default: []

property :owner, String, default: 'root'
property :group, String, default: 'root'

property :wwwroot, String, default: '/var/www/letsencrypt/'

property :key_size, Integer, default: node['certbot']['key_size'],
                             equal_to: [2048, 3072, 4096],
                             required: true

property :renew_policy, Symbol, default: :keep_until_expiring,
                                equal_to: [:keep_until_expiring, :renew_by_default]
