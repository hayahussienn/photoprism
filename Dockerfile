# Use base image (make sure it supports Node.js and Go)
FROM photoprism/develop:250217-oracular

# Set working directory
WORKDIR "/go/src/github.com/photoprism/photoprism"

# Install Node.js and npm (for frontend dependencies)
RUN apt-get update && apt-get install -y nodejs npm

# Copy source code
COPY . .

# Install dependencies
RUN go mod tidy # Ensure Go modules are installed
RUN cd frontend && npm install # Install frontend dependencies

# Build the application
RUN go build -o photoprism ./cmd/photoprism

# Expose the necessary port
EXPOSE 9090

# Run the application
CMD ["./photoprism", "start"]
