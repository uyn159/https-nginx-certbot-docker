   # Use Node.js LTS version as the base image
   FROM node:lts AS build

   # Set the working directory
   WORKDIR /app

   # Copy package.json and package-lock.json
   COPY package*.json ./

   # Install dependencies
   RUN npm install

   # Copy the rest of the application
   COPY . .

   # Build the React app
   RUN npm run build

   # Use Nginx as the base image for serving the React app
   FROM nginx:alpine

   # Copy build files from the previous stage
   COPY --from=build /app/build /usr/share/nginx/html

   # Expose port 80
   EXPOSE 80

   # Start Nginx
   CMD ["nginx", "-g", "daemon off;"]
   