# Step 1: Use a lightweight Nginx image to serve the Angular app
FROM nginx:alpine

# Step 2: Copy the compiled Angular app into Nginx's default directory
COPY ./dockerfile/frontend/dist/hr-connect-fe /usr/share/nginx/html

COPY ./dockerfile/frontend/assets/env.js /usr/share/nginx/html/assets/env.js

# Step 3: Expose the port that Nginx will serve the app on (default is 80)
EXPOSE 80

# Step 4: Run Nginx (this is the default behavior of the Nginx image)
CMD ["nginx", "-g", "daemon off;"]