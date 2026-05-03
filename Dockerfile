FROM node:24.14.0-slim AS base

LABEL fly_launch_runtime="Astro"

# Astro app lives here
WORKDIR /app

# Set production environment
ENV NODE_ENV="production"

# Enable pnpm via corepack
RUN corepack enable && corepack prepare pnpm@10.11.0 --activate


# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build node modules
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential node-gyp pkg-config python-is-python3

# Install node modules
COPY pnpm-lock.yaml package.json ./
RUN pnpm install --frozen-lockfile

# Copy application code
COPY . .

# Build application
RUN pnpm run build


# Final stage for app image
FROM nginx AS production

# Copy built application
COPY --from=build /app/dist /usr/share/nginx/html

# Start the server by default, this can be overwritten at runtime
EXPOSE 80
CMD [ "/usr/sbin/nginx", "-g", "daemon off;" ]
