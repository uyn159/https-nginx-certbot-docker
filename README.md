
# install cerbot

To install Certbot on an Ubuntu server, you can use the official Certbot PPA (Personal Package Archive) provided by the Certbot developers. Here's how you can install Certbot on Ubuntu:

1. **Add the Certbot PPA**:
   
   Run the following commands to add the Certbot PPA to your system:

   ```bash
   sudo apt update
   sudo apt install software-properties-common
   sudo add-apt-repository universe
   sudo add-apt-repository ppa:certbot/certbot
   ```

2. **Install Certbot**:

   After adding the PPA, you can install Certbot by running:

   ```bash
   sudo apt update
   sudo apt install certbot
   ```

3. **Verify Installation**:

   Once the installation is complete, you can verify that Certbot has been installed by running:

   ```bash
   certbot --version
   ```

   This command will display the version of Certbot installed on your system.

4. **Optional**: Install additional Certbot plugins if needed. For example, if you're using Nginx, you may want to install the Certbot Nginx plugin:

   ```bash
   sudo apt install python3-certbot-nginx
   ```

   This plugin allows Certbot to automate the process of obtaining and installing SSL certificates for Nginx.

Now Certbot should be installed on your Ubuntu server, and you can use it to obtain SSL certificates for your domains. Make sure to follow the appropriate steps for obtaining and configuring SSL certificates based on your specific requirements and environment.

# sudo certbot certonly --nginx -d your_domain.com -d www.your_domain.com
To move SSL certificates obtained with Certbot into your Docker Compose setup with Nginx, you need to mount the SSL certificates and keys into the Nginx container and update the Nginx configuration to use them. Here's how you can do it:

1. **Obtain SSL Certificates with Certbot**:

   Make sure you have obtained SSL certificates for your domain using Certbot on your host machine. The certificates will typically be located in the `/etc/letsencrypt/live/your_domain.com/` directory.

2. **Update Docker Compose Configuration**:

   Modify your `docker-compose.yml` file to include volumes for SSL certificates:

   ```yaml
   version: '3'
   services:
     nginx:
       image: nginx:latest
       ports:
         - "80:80"
         - "443:443"
       volumes:
         - ./nginx.conf:/etc/nginx/nginx.conf
         - /etc/letsencrypt/live/your_domain.com/fullchain.pem:/etc/nginx/certs/fullchain.pem
         - /etc/letsencrypt/live/your_domain.com/privkey.pem:/etc/nginx/certs/privkey.pem
       restart: always
   ```

   Ensure that you replace `your_domain.com` with your actual domain name.

3. **Update Nginx Configuration**:

   Modify your Nginx configuration file (`nginx.conf`) to use the mounted SSL certificates:

   ```nginx
   events {}

   http {
     server {
       listen 80;
       listen 443 ssl;
       server_name your_domain.com;

       ssl_certificate /etc/nginx/certs/fullchain.pem;
       ssl_certificate_key /etc/nginx/certs/privkey.pem;

       location / {
         # Proxy configuration for your React app
       }
     }
   }
   ```

   Ensure that you replace `your_domain.com` with your actual domain name.

4. **Launch the Docker Containers**:

   Run `docker-compose up -d` to start your Docker containers. Nginx will use the SSL certificates mounted from the host machine.

5. **Testing**:

   Verify that your website is accessible over HTTPS. You can use a web browser to visit `https://your_domain.com` and ensure that the SSL connection is secure.

By following these steps, you can move SSL certificates obtained with Certbot into your Docker Compose setup with Nginx, enabling secure HTTPS connections to your website.