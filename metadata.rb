name             'certbotssl'
maintainer       'Fabio Todaro'
maintainer_email 'fabio.todaro@crweb.it'
license          'Apache-2.0'
description      'Installs/Configures certbot'
source_url       'https://github.com/Creatiweb/chef-certbot'
issues_url       'https://github.com/Creatiweb/chef-certbot/issues'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
chef_version '>= 12'

supports 'ubuntu', '>= 14.04'
supports 'debian', '>= 8'
supports 'centos', '>= 7'
supports 'redhat', '>= 7'

depends 'cron', '~> 4.1.3'
