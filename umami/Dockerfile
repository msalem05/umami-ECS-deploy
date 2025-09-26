#Stage 1:Build Stage

FROM node:22-alpine AS build
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package*.json pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install --frozen-lockfile
COPY . .

ARG DATABASE_TYPE
ENV DATABASE_TYPE=$DATABASE_TYPE

RUN pnpm run build-docker

#Stage 2: Production Stage

FROM node:22-alpine AS runner
RUN apk add --no-cache libc6-compat
WORKDIR /app

ENV NODE_ENV=production 

RUN npm install -g pnpm
RUN pnpm add npm-run-all dotenv prisma@6.7.0

COPY --from=build /app/prisma ./prisma
COPY --from=build /app/public ./public
COPY --from=build /app/.next/standalone ./
COPY --from=build /app/.next/static ./.next/static
COPY --from=build /app/scripts ./scripts

EXPOSE 3000
CMD [ "pnpm" , "start-docker"]


