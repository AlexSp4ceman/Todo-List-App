FROM node:18-alpine
RUN apk add --no-cache apache2
RUN echo "LoadModule proxy_module modules/mod_proxy.so" >> /etc/apache2/httpd.conf
RUN echo "LoadModule proxy_http_module modules/mod_proxy_http.so" >> /etc/apache2/httpd.conf
RUN echo "ProxyRequests Off" >> /etc/apache2/httpd.conf
RUN echo "ProxyPreserveHost On" >> /etc/apache2/httpd.conf
RUN echo "ProxyPass /api http://localhost:3000/api" >> /etc/apache2/httpd.conf
RUN echo "ProxyPassReverse /api http://localhost:3000/api" >> /etc/apache2/httpd.conf

WORKDIR /app/backend

COPY backend/package*.json ./
RUN npm ci --only=production

COPY backend/ ./

COPY . /var/www/localhost/htdocs/

RUN rm -rf /var/www/localhost/htdocs/backend /var/www/localhost/htdocs/Dockerfile /var/www/localhost/htdocs/docker-compose.yml

EXPOSE 80 3000

CMD ["sh", "-c", "httpd && node server.js"]