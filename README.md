# CERTBOTSSL Cookbook

Install Certbot and automatically get/renew free and trusted certificates from Let's Encrypt (letsencrypt.org).

### Platforms

- Ubuntu > 14.04
- Debian >= 8
- CentOS/RHEL >= 7

### Chef

- Chef 12.0 or later

## Attributes

| Attribute             | Description                                                                                                                                                              | Default                                                                          |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |  ------------------------------------------------------------------------------: |
| contact               | Contact information, default empty. Set to `your@email.com`                                                                                                              | []                                                                               |
| endpoint              | ACME server endpoint, Set to `https://acme-staging.api.letsencrypt.org` if you want to use the Let's Encrypt staging environment and corresponding certificates.         | `https://acme-v01.api.letsencrypt.org`                                           |
| key_size              | Default private key size used when resource property is not. Must be one out of: 2048, 3072, 4096.                                                                       | 2048                                                                             |
| cron.frequency        | Frequency of renewal execution, set with cron syntax.                                                                                                                    | `{'minute' => '0','hour' => '*/12','day' => '*','month' => '*','weekday' => '*'}`|
| cron.hooks.pre-hook   | Command to be run in a shell before obtaining any certificates.                                                                                                          | ''                                                                               |
| cron.hooks.post-hook  | Command to be run in a shell after attempting to obtain/renew certificates.                                                                                              | ''                                                                               |
| cron.hooks.renew-hook | Command to be run in a shell once for each successfully renewed certificate.                                                                                             | ''                                                                               |

## Recipes
-------
### default
Installs certbot.

### cron
Configure renew cron.

## Usage

Use the `certbotssl_certificate` resource to request a certificate. The webserver for the domain for which you are requesting a certificate must be running on the local server. Provide the path to your `wwwroot` for the specified domain.

```ruby
certbotssl_certificate 'example.com' do
  wwwroot           '/var/www/letsencrypt'
  alt_names         ['www.example.com']
end
```

In case your webserver needs an already existing certificate when installing a new server you will have a bootstrap problem. Webserver cannot start without certificate, but the certificate cannot be requested without the running webserver. To overcome this a self-signed certificate can be generated with the `certbotssl_selfsigned` resource.

```ruby
certbot_selfsigned 'example.com' do
  alt_names         ['www.example.com']
end
```

A working example can be found in the included `certbotssl_test` test cookbook.

## Providers

### certificate
| Property            | Type    | Default             | Description                                            |
|  ---                |  ---    |  ---                |  ---                                                   |
| `cn`                | string  | _name_              | The common name for the certificate                    |
| `alt_names`         | array   | []                  | The alternative names for the certificate              |
| `owner`             | string  | root                | Owner of the created files                             |
| `group`             | string  | root                | Group of the created files                             |
| `key_size`          | integer | 2048                | Private key size. Must be one out of: 2048, 3072, 4096 |
| `wwwroot`           | string  | /var/www            | Path to the wwwroot of the domain                      |
| `renew_policy`      | string  | keep_until_expiring | Renew policy: keep_until_expiring, renew_by_default    |
| `ignore_failure`    | boolean | false               | Whether to continue chef run if issuance fails         |
| `retries`           | integer | 0                   | Number of times to catch exceptions and retry          |
| `retry_delay`       | integer | 2                   | Number of seconds to wait between retries              |

### selfsigned
| Property            | Type    | Default  | Description                                            |
|  ---                |  ---    |  ---     |  ---                                                   |
| `cn`                | string  | _name_   | The common name for the certificate                    |
| `alt_names`         | array   | []       | The alternative names for the certificate              |
| `key_size`          | integer | 2048     | Private key size. Must be one out of: 2048, 3072, 4096 |
| `owner`             | string  | root     | Owner of the created files                             |
| `group`             | string  | root     | Group of the created files                             |

## Example

To generate a certificate for an apache2 website you can use code like this:

```ruby
# Include the recipe to install certbot
include_recipe 'certbotssl'


# Set up contact information. Note the mailto: notation
node.set['certbot']['contact'] = ['me@example.com']
# letsencrypt production endpoint
node.set['certbot']['endpoint'] = 'https://acme-v01.api.letsencrypt.org'

app_name = 'example.com'
app_root = ::File.join('/var/www/', app_name)

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
```

## Testing

The kitchen includes a `boulder` server to run the integration tests with, so testing can run locally without interaction with the online API's.

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

Authors: Fabio Todaro

## Credits

Let’s Encrypt is a trademark of the Internet Security Research Group. All rights reserved.

https://ietf-wg-acme.github.io/acme/
https://letsencrypt.org/

Certbot is published by the Electronic Frontier Foundation. All rights reserved.

https://certbot.eff.org
