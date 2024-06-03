# Stage 1: Install dependencies
FROM node:18-alpine AS deps

RUN apk add --no-cache libc6-compat
RUN npm install -g pnpm@8.10.2

WORKDIR /apps

# Copy root workspace files
COPY start.sh package.json pnpm-lock.yaml pnpm-workspace.yaml turbo.json ./
COPY ./ ./

# Install root dependencies
RUN pnpm install --frozen-lockfile

# Stage 2: Build the specific application
FROM deps AS builder

WORKDIR /apps

# Argument to specify the app name
ARG APP_NAME

# Copy only the specific app directory based on the build argument
COPY ./ ./



# Stage 3: Create the production image
FROM node:18-alpine AS runner

WORKDIR /apps/${APP_NAME}

ENV NODE_ENV dev


RUN apk add --no-cache libc6-compat
RUN npm install -g pnpm@8.10.2

RUN addgroup --system --gid 1001 nodejs \
  && adduser --system --uid 1001 nextjs

# Argument to specify the app name
ARG APP_NAME

# Copy only the specific app directory from the builder stage
COPY --from=builder /apps/packages ./packages
COPY --from=builder /apps/templates ./templates
COPY --from=builder /apps/node_modules ./node_modules
COPY --from=builder /apps/apps/${APP_NAME}  ./apps/${APP_NAME}
COPY --from=builder /apps/package.json ./package.json
COPY --from=builder /apps/pnpm-lock.yaml ./pnpm-lock.yaml
COPY --from=builder /apps/cspell.json ./cspell.json
COPY --from=builder /apps/pnpm-workspace.yaml ./pnpm-workspace.yaml
COPY --from=builder /apps/turbo.json ./turbo.json
COPY --from=builder /apps/start.sh ./start.sh
COPY --from=builder /apps/syncpack.config.js ./syncpack.config.js

# Set permissions for the nextjs user
RUN chown -R nextjs:nodejs /apps

USER nextjs

EXPOSE 3000

ENV PORT 3000

CMD ["pnpm", "run", "dev"]
