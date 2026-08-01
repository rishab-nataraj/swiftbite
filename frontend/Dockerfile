# ---- SwiftBite Frontend: React (Vite) dev server ----
# Development image: gives hot-reload, which is what "local development" needs.
FROM node:20-alpine

WORKDIR /app

# Install dependencies first so this layer is cached between code changes
COPY package.json ./
RUN npm install

# Copy application source
COPY . .

EXPOSE 5173

CMD ["npm", "run", "dev"]
