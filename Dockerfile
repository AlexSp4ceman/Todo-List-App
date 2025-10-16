FROM node:18-alpine AS backend-build
WORKDIR /app/backend
COPY backend/package*.json ./
RUN npm ci --only=production
COPY backend/ ./

FROM httpd:2.4-alpine AS frontend

COPY index.html /usr/local/apache2/htdocs/

COPY --from=backend-build /app/backend /usr/local/apache2/htdocs/backend

WORKDIR /usr/local/apache2/htdocs/backend

EXPOSE 80 3000

CMD ["sh", "-c", "httpd-foreground & node server.js"]