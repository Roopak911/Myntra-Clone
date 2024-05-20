# Use node:alpine as the base image
FROM node:alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.jason to the container
COPY package.json package-lock.json ./

# Install dependencies
RUN npm Install

# Copy the entire project to the container
COPY . .

# Build the react app
RUN npm run Build

# Expose port 3000
EXPOSE 3000

# Start the react app
CMD ["npm", "start"]