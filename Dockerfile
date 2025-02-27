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

# ✅ Fix: Ensure assets directory exists
RUN mkdir -p /go/src/github.com/photoprism/photoprism/assets \
    && chmod -R 777 /go/src/github.com/photoprism/photoprism/assets

# ✅ Ensure storage directories exist and are writable
RUN mkdir -p /go/src/github.com/photoprism/photoprism/storage \
    && chmod -R 777 /go/src/github.com/photoprism/photoprism/storage

# ✅ Set environment variables
ENV PHOTOPRISM_ASSETS_PATH="/go/src/github.com/photoprism/photoprism/assets"
ENV PHOTOPRISM_STORAGE_PATH="/go/src/github.com/photoprism/photoprism/storage"
ENV PHOTOPRISM_HTTP_PORT="9090"
ENV PHOTOPRISM_HTTP_HOST="0.0.0.0"

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

# Run the application
CMD ["./photoprism", "start"]
