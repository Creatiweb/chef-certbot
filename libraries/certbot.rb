module CertBot
  def self.certificate_dir(main_dir, domain)
    File.join(main_dir, domain)
  end
  def self.hooks_args(hooks)
    hooks_args = ''
    hooks.each do |hookname, hook|
      hooks_args += !hook.to_str.empty? ? "--#{hookname} '#{hook}' " : ''
    end
    hooks_args
  end
  def self.self_signed_cert(cn, alts, key)
    cert = OpenSSL::X509::Certificate.new
    cert.subject = cert.issuer = OpenSSL::X509::Name.new([['CN', cn, OpenSSL::ASN1::UTF8STRING]])
    cert.not_before = Time.now
    cert.not_after = Time.now + 60 * 60 * 24 * 30
    cert.public_key = key.public_key
    cert.serial = 0x0
    cert.version = 2

    ef = OpenSSL::X509::ExtensionFactory.new
    ef.subject_certificate = cert
    ef.issuer_certificate = cert

    cert.extensions = []

    alts.unshift(cn)

    cert.extensions += [ef.create_extension('basicConstraints', 'CA:FALSE', true)]
    cert.extensions += [ef.create_extension('subjectKeyIdentifier', 'hash')]
    cert.extensions += [ef.create_extension('subjectAltName', alts.map { |d| "DNS:#{d}"}.join(','))] if alts.length > 0

    cert.sign key, OpenSSL::Digest::SHA256.new
  end
end
