# Use the official lightweight Node.js 14 image
FROM node:14 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the dependencies file to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the project files to the working directory
COPY . .

# Build the React app
RUN npm run build

# Use Nginx image as the base image
FROM nginx:alpine

# Copy the React app build files to the Nginx html directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
