source 'https://supermarket.chef.io'

metadata

# Force aws cookbook to not require ohai 2.1.0+, which is incompatible with
# nginx 2.4.x
cookbook 'aws', '< 2.9.0'

# Force iptables to 1.x, as 2.x brings in compat_resource, which is incompatible
# with chef 11.x
cookbook 'iptables', '~> 1.1'

# Make doubly sure that ohai 1.1.x is used instead of 2.1.0+
cookbook 'ohai', '~> 1.1'

# Ensure yum::epel is not required by nginx by forcing a requirement for 3.x
cookbook 'yum', '>= 3.0'
