apt-get install -y docker.io git
usermod -aG docker vagrant 

# run standard "green" app container, from existing repo
   docker run -d -p 8000:80 --name netty-green dancave/netty-green:latest
cat > ~vagrant/conf.d/proxy.conf << EOF
server {
        listen 80;
        listen [::]:80;

        access_log /var/log/nginx/reverse-access.log;
        error_log /var/log/nginx/reverse-error.log;

        location / {
                    proxy_pass http://172.17.0.2:80;
        }

        # location /blue {
        #             proxy_pass http://netty-blue:80;
        # }
}

EOF

#sudo perl -ni -e 'print; print "172.17.0.2     netty-green\n172.17.0.3     netty-blue\n"  if $. == 7' /etc/hosts

# apt-get install -y nginx