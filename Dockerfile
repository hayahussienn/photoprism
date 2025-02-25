# Use base image
FROM photoprism/develop:250217-oracular

# Set working directory
WORKDIR "/go/src/github.com/photoprism/photoprism"

# Copy source code
COPY . .

# Install dependencies
RUN go mod tidy # Ensure Go modules are installed
RUN cd frontend && npm install && npm audit fix --force # Fix npm security issues

# Run tests **inside the container**
RUN make test-js && go test ./internal/...  # Run tests inside Docker build step

# Build the application
RUN go build -o photoprism ./cmd/photoprism

# Expose the necessary port
EXPOSE 9090

# Run the application
CMD ["./photoprism", "start"]
