actions :create
default_action :create

property :cn, String, name_property: true
property :alt_names, Array, default: []

property :owner, String, default: 'root'
property :group, String, default: 'root'

property :key_size, Integer, default: node['certbot']['key_size'],
                             equal_to: [2048, 3072, 4096],
                             required: true
