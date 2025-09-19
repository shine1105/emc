# Builder stage
# FROM oven/bun:1.1.18-alpine AS builder
# WORKDIR /app
# COPY package.json ./
# RUN bun install --frozen-lockfile
# COPY . .
# FROM oven/bun:1.1.18-alpine
# WORKDIR /app
# COPY . .
# EXPOSE 3000
# CMD ["bun", "run", "src/index.ts"]
 


# FROM oven/bun:1.1.18-alpine AS builder

# WORKDIR /app
# COPY . .
# RUN apk add --no-cache binutils
# RUN bun install --frozen-lockfile && \
#     bun build src/index.ts --compile --minify --outfile output && \
#     strip output
# FROM gcr.io/distroless/base-debian12 AS runner

# WORKDIR /app
# COPY --from=builder /app/output .

# EXPOSE 3000
# CMD ["./output"]

# FROM oven/bun:1.1.18-alpine AS builder

# WORKDIR /app
# COPY . .

# RUN apk update && apk add --no-cache binutils

# RUN bun install --frozen-lockfile
# RUN bun build src/index.ts --compile --minify --bytecode --outfile output && strip output

# FROM public.ecr.aws/amazonlinux/amazonlinux:latest

# WORKDIR /app
# COPY --from=builder /app/output .

# RUN dnf update -y && dnf install -y libstdc++

# EXPOSE 3000
# CMD ["./output"]


# FROM oven/bun:1.1.18-alpine AS builder

# WORKDIR /app
# COPY . .
# RUN apk add --no-cache binutils file
# RUN bun install --frozen-lockfile
# RUN bun build src/index.ts --compile --minify --outfile /app/output \
#     && strip /app/output \
#     && file /app/output \
#     && ls -lh /app/output
# FROM alpine:edge
# RUN apk add --no-cache gcompat libstdc++

# WORKDIR /app
# COPY --from=builder /app/output /app/output

# EXPOSE 3000
# CMD ["/app/output"]

 
FROM oven/bun:1.1.18-alpine AS builder
 
WORKDIR /app
COPY . .
 
RUN bun install --frozen-lockfile
RUN bun build ./src/index.ts --compile --outfile output && chmod +x output
 
FROM debian:bullseye-slim
 
WORKDIR /app
 
RUN apt-get update && apt-get install -y \
    libc6 libstdc++6 libgcc-s1 ca-certificates && \
    rm -rf /var/lib/apt/lists/*
 
COPY --from=builder /app/output .
 
EXPOSE 3000
CMD ["./output"]

# FROM oven/bun:1.1.18-alpine AS builder
# WORKDIR /app
# COPY . .
# RUN bun install --frozen-lockfile
# RUN bun build src/index.ts --compile --outfile output && chmod +x output
 
# FROM oven/bun:1.1.18-alpine
# WORKDIR /app
# COPY --from=builder /app/output .
 
# CMD ["./output"]

