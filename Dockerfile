# Use base image
FROM photoprism/develop:250217-oracular

# Set working directory
WORKDIR "/go/src/github.com/photoprism/photoprism"

# Install Node.js & npm (ensure it's available)
RUN apt-get update && apt-get install -y nodejs npm

# Copy source code
COPY . .

# Install dependencies **without forcing audit fix**
RUN go mod tidy # Ensure Go modules are installed
RUN cd frontend && npm install --legacy-peer-deps # Fix potential dependency conflicts

# Run tests **inside the container**
RUN make test-js && go test ./internal/...

# Build the application
RUN go build -o photoprism ./cmd/photoprism

# Expose the necessary port
EXPOSE 9090

# Run the application
CMD ["./photoprism", "start"]
