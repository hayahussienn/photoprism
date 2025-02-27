# Use base image
FROM photoprism/develop:250217-oracular

# Set working directory
WORKDIR "/go/src/github.com/photoprism/photoprism"

# Install Node.js & npm properly
RUN apt-get update && apt-get install -y curl \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Verify installation
RUN node -v && npm -v

# Copy source code
COPY . .

# ✅ Fix: Ensure assets directory exists & set correct ownership
RUN mkdir -p /go/src/github.com/photoprism/photoprism/assets \
    && chmod -R 777 /go/src/github.com/photoprism/photoprism/assets \
    && chown -R 1000:1000 /go/src/github.com/photoprism/photoprism/assets

# ✅ Ensure storage directories exist and are writable
RUN mkdir -p /go/src/github.com/photoprism/photoprism/storage \
    && chmod -R 777 /go/src/github.com/photoprism/photoprism/storage \
    && chown -R 1000:1000 /go/src/github.com/photoprism/photoprism/storage

# ✅ Set environment variables
ENV PHOTOPRISM_ASSETS_PATH="/go/src/github.com/photoprism/photoprism/assets"
ENV PHOTOPRISM_STORAGE_PATH="/go/src/github.com/photoprism/photoprism/storage"
ENV PHOTOPRISM_HTTP_PORT="9090"
ENV PHOTOPRISM_HTTP_HOST="0.0.0.0"

# ✅ Additional required environment variables
ENV PHOTOPRISM_PUBLIC="false"
ENV PHOTOPRISM_READONLY="false"
ENV PHOTOPRISM_DATABASE_DRIVER="sqlite"
ENV PHOTOPRISM_DATABASE_NAME="photoprism.db"
ENV PHOTOPRISM_UPLOAD_NSFW="true"
ENV PHOTOPRISM_DETECT_NSFW="false"
ENV PHOTOPRISM_EXPERIMENTAL="true"
ENV PHOTOPRISM_SITE_URL="http://localhost:9090/"
ENV PHOTOPRISM_DEBUG="true"
ENV PHOTOPRISM_LOG_LEVEL="debug"

# ✅ Install Go dependencies before building
RUN go mod tidy
RUN go mod download

# ✅ Install frontend dependencies safely
RUN cd frontend && npm install --legacy-peer-deps

# ✅ Build the frontend assets
RUN cd frontend && npm run build

# ✅ Build the Go application
RUN go build -o photoprism ./cmd/photoprism

# Expose port 9090
EXPOSE 9090

# ✅ Initialize database & start
CMD ["./photoprism", "migrate", "start"]
