# ---------- Stage 1: Build ----------
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json first (for caching)
COPY package*.json ./

# Install dependencies
RUN npm install --frozen-lockfile

# Copy the rest of the application
COPY . .

# Build the NestJS app
RUN npm run build

# ---------- Stage 2: Production image ----------
FROM node:20-alpine AS production

WORKDIR /app

# Copy only production dependencies
COPY package*.json ./
RUN npm install --prod --frozen-lockfile

# Copy built files from builder
COPY --from=builder /app/dist ./dist


# Expose the port your NestJS app runs on
EXPOSE 3000

# Run the application
CMD ["node", "dist/main.js"]
