#!/bin/sh

# Source in util.sh so we can have our nice tools
. $(cd $(dirname $0); pwd)/util.sh

# We require an email to register the ssl certificate for
if [ -z "$CERTBOT_EMAIL" ]; then
    error "CERTBOT_EMAIL environment variable undefined; certbot will do nothing"
    exit 1
fi

# Get this machine's ip
ip=$(curl -sS ipinfo.io/ip)
if [ -z "$ip" ]; then
    error "Unable to obtain this machine's ip"
    exit 1
fi
echo "This machine's ip is $ip"

exit_code=0
set -x
# Loop over every domain we can find
for domain in $(parse_domains); do
    # Check domain resolution
    domain_ip=$(dig +short $domain)
    if [ "$ip" != "$domain_ip" ]; then
        echo "Skipping $domain (resolves to $domain_ip)"
        continue
    else
        echo "$domain resolves correctly ($domain_ip)"
    fi
    # Get certificate
    if ! get_certificate $domain $CERTBOT_EMAIL; then
        error "Cerbot failed for $domain. Check the logs for details."
        exit_code=1
    fi
done

# After trying to get all our certificates, auto enable any configs that we
# did indeed get certificates for
auto_enable_configs

# Print nginx configuration test
echo "$(nginx -t)"

# Finally, tell nginx to reload the configs
kill -HUP $NGINX_PID

set +x
exit $exit_code
