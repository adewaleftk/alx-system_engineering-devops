# Puppet manifest to install and configure Nginx server with 301 redirect and custom 404 page
# customizing error 404

# Install Nginx package
package { 'nginx':
  ensure => 'installed',
}

# Replace default Nginx config file with custom config file
file { '/etc/nginx/sites-available/default':
  ensure  => 'file',
  content => "
    server {
      listen 80 default_server;
      listen [::]:80 default_server;

      root /var/www/html;
      index index.html;

      server_name _;

      location / {
        try_files \$uri \$uri/ =404;
      }

      location /redirect_me {
        return 301 https://www.example.com/;
      }

      error_page 404 /404.html;
      location = /404.html {
        internal;
        root /var/www/html;
        echo 'Ceci n\'est pas une page.';
      }
    }
  ",
}

# Restart Nginx service
exec { 'nginx-restart':
  command => '/usr/sbin/service nginx restart',
  path    => '/usr/bin:/usr/sbin:/bin',
  require => [Package['nginx'], File['/etc/nginx/sites-available/default']],
}

# Verify Nginx is running and serving expected page
file { '/var/www/html/index.html':
  ensure  => 'file',
  content => 'Hello World!',
}

# Test Nginx is serving expected page
exec { 'test-nginx':
  command => 'curl -s localhost | grep -q "Hello World!"',
  path    => '/usr/bin:/usr/sbin:/bin',
  require => [Package['curl'], Service['nginx'], File['/var/www/html/index.html']],
}

