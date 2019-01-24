# docker-nginx-certbot
Create and automatically renew website SSL certificates using the LetsEncrypt free certificate authority, and its client *certbot*, built on top of the nginx server.

# More information

Find out more about letsencrypt: https://letsencrypt.org

Certbot github: https://github.com/certbot/certbot

This repository was forked from `@staticfloat`, many thanks to him for the good code.  It remains close to the original, I've just added a few tweaks to suit my needs:
- Certbot will only request certificates for domains in `*.certbot.conf` files
- Certbot will not request certificates if the domain does not resolve to the machine's IP

Handling conf files in this way allows nginx to remain open to unencrypted traffic if the certificate is missing, and to simultaneously use other certificate authorities or
self signed certificates.

# Usage

Use this image with a `Dockerfile` such as:
```Dockerfile
FROM nualartlee/nginx-certbot
COPY *.conf /etc/nginx/conf.d/
```

Add a `.conf` file for unencrypted traffic.
Include certbot's url location as below:
```nginx
server {
	listen	80;
	listen	[::]:80;
	server_name mysite.com;

	# Pass this particular URL off to certbot, to authenticate HTTPS certificates
	location /.well-known/acme-challenge {
	  default_type "text/plain";
	  proxy_pass http://localhost:1337;
        }

        # Everything else gets served by the site
        location / {

            # Serve the site unencrypted
            root /www;

	    # Optionally, redirect to https
            #return 301 https://$http_host$request_uri;
        }
}
```

Add a `.certbot.conf` file for LetsEncrypt certified https traffic.
Specify the certificate locations according to the certbot standard.
If the certificate request fails, or if the domain does not point here,
this file will be disabled appending `.nokey`.
```nginx
server {
	listen      443 ssl;
	listen      [::]:443 ssl;
	server_name mysite.com;
	ssl_certificate     /etc/letsencrypt/live/mysite.com/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/mysite.com/privkey.pem;

	location / {
        root /www;
	}
}
```

Wrap this all up with a `docker-compose.yml` file:
```yml
version: '3'
services:
    frontend:
        restart: unless-stopped
        build: frontend
        ports:
            - 80:80/tcp
            - 443:443/tcp
        environment:
            - CERTBOT_EMAIL=owner@mysite.com
  ...
```

# Changelog

### 0.9
- Forked form Staticfloat to modify for my needs; Thanks Staticfloat!
- Change nginx startup to kill lingering processes and to specify pid file location for reloads.
- Certbot will only request certificates for config files in the *.certbot.conf format.
- Certbot will only request certificates for domains pointing to the running machine's IP

### 0.8
- Ditch cron, it never liked me anway.  Just use `sleep` and a `while` loop instead.

### 0.7
- Complete rewrite, build this image on top of the `nginx` image, and run `cron`/`certbot` alongside `nginx` so that we can have nginx configs dynamically enabled as we get SSL certificates.

### 0.6
- Add `nginx_auto_enable.sh` script to `/etc/letsencrypt/` so that users can bring nginx up before SSL certs are actually available.

### 0.5
- Change the name to `docker-certbot-cron`, update documentation, strip out even more stuff I don't care about.

### 0.4
- Rip out a bunch of stuff because `@staticfloat` is a monster, and likes to do things his way

### 0.3
- Add support for webroot mode.
- Run certbot once with all domains.

### 0.2
- Upgraded to use certbot client
- Changed image to use alpine linux

### 0.1
- Initial release
