# Stage 1: Build the React app
FROM node:20.13.1-alpine3.19 AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Serve the React app using a lightweight web server
FROM nginx:stable-alpine3.19

# Copy the built files from the previous stage
COPY --from=build /app/dist /usr/share/nginx/html

# Copy the nginx configuration file
COPY config/nginx.conf /etc/nginx/nginx.conf

# Adjust permissions for Nginx
RUN chown -R nginx:nginx /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
