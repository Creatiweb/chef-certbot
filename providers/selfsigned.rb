use_inline_resources

def whyrun_supported?
  true
end

action :create do

  selfsigned_dir = "#{node['certbot']['working_dir']}/selfsigned/#{new_resource.cn}"
  key = ::File.join(selfsigned_dir, 'privkey.pem')
  cert = ::File.join(selfsigned_dir, 'cert.pem')
  chain = ::File.join(selfsigned_dir, 'chain.pem')

  directory selfsigned_dir do
    recursive true
  end

  directory node['certbot']['cert_dir'] do
    recursive true
  end

  file "#{new_resource.cn} SSL selfsigned key" do
    path      key
    owner     new_resource.owner
    group     new_resource.group
    mode      00400
    content   OpenSSL::PKey::RSA.new(new_resource.key_size).to_pem
    sensitive true
    action    :create_if_missing
  end

  file "#{new_resource.cn} SSL selfsigned crt" do
    path    cert
    owner   new_resource.owner
    group   new_resource.group
    mode    00644
    content lazy { CertBot.self_signed_cert(new_resource.cn, new_resource.alt_names, OpenSSL::PKey::RSA.new(::File.read(key))).to_pem }
    action  :create_if_missing
  end

  file "#{new_resource.cn} SSL selfsigned chain" do
    path    chain
    owner   new_resource.owner
    group   new_resource.group
    mode    00644
    content lazy { CertBot.self_signed_cert(new_resource.cn, new_resource.alt_names, OpenSSL::PKey::RSA.new(::File.read(key))).to_pem }
    action  :create_if_missing
  end

  link CertBot.certificate_dir(node['certbot']['cert_dir'], new_resource.cn) do
    to selfsigned_dir
    not_if "test -L #{CertBot.certificate_dir(node['certbot']['cert_dir'], new_resource.cn)}"
  end
end
