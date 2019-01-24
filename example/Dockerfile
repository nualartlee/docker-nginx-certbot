FROM nualartlee/nginx-certbot


# Copy all your nginx site config files to /etc/nginx/conf.d/
#
# Certbot will request certificates for domains in config files ending in .certbot.conf
# that resolve to this machine's IP address.
# The machine's external IP is obtained from ipinfo.io and the domain IP from dig.
#
# Excluding the .certbot suffix allows having config files referencing self-signed or
# locally administered certificates without unnecessarily polling LetsEncrypt
#
# Any conf file referencing a non-existent certificate will be disabled appending .nokey
# It is helpful to separate http and https for your domains in two distinct files, so
# if the certificate is not present the site is still available unencrypted.
#
#
# In your http (unencrypted) config file, pass this particular URL off to certbot
# to authenticate HTTPS certificates:
# location '/.well-known/acme-challenge' {
#     default_type "text/plain";
#     proxy_pass http://localhost:1337;
# }
COPY *.conf /etc/nginx/conf.d/


# If required, copy a default nginx configuration.
#COPY nginx.default /etc/nginx/nginx.conf

# www files to serve with the provided examples
COPY www /www

