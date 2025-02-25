# Start with a base image that includes Go 1.23.5
FROM golang:1.23.5 AS builder

# Set working directory inside the container
WORKDIR /app

# Copy source code into the container
COPY . .

# Install dependencies
RUN go mod tidy  # Ensure go modules are installed
RUN cd frontend && npm install  # Install frontend dependencies

# Build the application
RUN go build -o myapp ./...

# Start a new container for the final image
FROM ubuntu:24.04
WORKDIR /app

# Copy the built application from the previous step
COPY --from=builder /app/myapp .

# Expose the application port
EXPOSE 9090

# Run the application
CMD ["./myapp"]
