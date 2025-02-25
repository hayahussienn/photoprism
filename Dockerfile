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

# Install dependencies
RUN go mod tidy # Ensure Go modules are installed
RUN cd frontend && npm install --legacy-peer-deps  # Fix npm issues

# Run tests **inside the container**
RUN make test-js && go test ./internal/...

# Build the application
RUN go build -o photoprism ./cmd/photoprism

# Expose the necessary port
EXPOSE 9090

# Run the application
CMD ["./photoprism", "start"]
