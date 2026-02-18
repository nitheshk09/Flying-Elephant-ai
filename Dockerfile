# Use Node.js LTS version
FROM node:18-slim

# Set working directory
WORKDIR /app

# Copy package files from the server directory
COPY server/package*.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of the server code
COPY server/ .

# Expose the port
EXPOSE 3000

# Start the application
CMD ["node", "index.js"]
