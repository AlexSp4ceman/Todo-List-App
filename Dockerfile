FROM node:18-alpine
RUN apk add --no-cache apache2
WORKDIR /app/backend

COPY backend/package*.json ./
RUN npm ci --only=production

COPY backend/ ./

COPY . /var/www/localhost/htdocs/

RUN echo "ServerName localhost" >> /etc/apache2/httpd.conf

EXPOSE 80 3000

CMD ["sh", "-c", "httpd && node server.js"]