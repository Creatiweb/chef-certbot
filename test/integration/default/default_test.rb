describe package('certbot') do
  it { should be_installed }
end

describe command('certbot') do
  it { should exist }
end

describe directory('/etc/letsencrypt') do
  it { should exist }
end

describe file('/etc/cron.d/letsencrypt') do
  it { should exist }
  it { should be_file }
  its('content') { should include '0 */12 * * * root /usr/bin/certbot renew -q --renew-hook \'service httpd reload\'' }
end


describe file('/etc/letsencrypt/live/example.com/privkey.pem') do
  it { should exist }
end
describe file('/etc/letsencrypt/live/example.com/cert.pem') do
  it { should exist }
end
describe file('/etc/letsencrypt/live/example.com/chain.pem') do
  it { should exist }
end

describe file('/etc/letsencrypt/selfsigned/example.com/privkey.pem') do
  it { should exist }
end
describe file('/etc/letsencrypt/selfsigned/example.com/cert.pem') do
  it { should exist }
end
describe file('/etc/letsencrypt/selfsigned/example.com/chain.pem') do
  it { should exist }
end

describe directory('/etc/letsencrypt/current/example.com') do
  it { should exist }
  it { should be_linked_to '/etc/letsencrypt/live/example.com' }
end

describe x509_certificate('/etc/letsencrypt/selfsigned/example.com/cert.pem') do
  its('extensions.subjectAltName') { should include 'DNS:example.com' }
  its('extensions.subjectAltName') { should include 'DNS:www.example.com' }
end

describe x509_certificate('/etc/letsencrypt/live/example.com/cert.pem') do
  its('extensions.subjectAltName') { should include 'DNS:example.com' }
  its('extensions.subjectAltName') { should include 'DNS:www.example.com' }
end
