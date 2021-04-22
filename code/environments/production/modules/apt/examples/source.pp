# Declare the apt class to manage /etc/apt/sources.list and /etc/sources.list.d
class { 'apt': }

# Install the puppetlabs apt source
# Release is automatically obtained from lsbdistcodename fact if available.
apt::source { 'puppetlabs':
  location => 'http://apt.puppetlabs.com',
  repos    => 'main',
  key      => {
    id     => '6F6B15509CF8E59E6E469F327F438280EF8D349F',
    server => 'hkps.pool.sks-keyservers.net',
  },
}

# test two sources with the same key
apt::source { 'debian_testing':
  location => 'http://debian.mirror.iweb.ca/debian/',
  release  => 'testing',
  repos    => 'main contrib non-free',
  key      => {
    id     => 'A1BD8E9D78F7FE5C3E65D8AF8B48AD6246925553',
    server => 'hkps.pool.sks-keyservers.net',
  },
  pin      => '-10',
}
apt::source { 'debian_unstable':
  location => 'http://debian.mirror.iweb.ca/debian/',
  release  => 'unstable',
  repos    => 'main contrib non-free',
  key      => {
    id     => 'A1BD8E9D78F7FE5C3E65D8AF8B48AD6246925553',
    server => 'hkps.pool.sks-keyservers.net',
  },
  pin      => '-10',
}
