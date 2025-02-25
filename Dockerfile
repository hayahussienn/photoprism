# Base image (Ubuntu-based with Go)
FROM golang:1.21 AS build

# Set working directory
WORKDIR /app

# Copy everything
COPY . .

# Install dependencies
RUN go mod tidy
RUN cd frontend && npm install

# Run tests
RUN go test ./internal/... -v
RUN cd frontend && npm run test

# Build the application
RUN go build -o photoprism-app

# Use a smaller image for the final app
FROM ubuntu:24.10
WORKDIR /app
COPY --from=build /app/photoprism-app .

# Expose port 9090 (change from 8080)
EXPOSE 9090

# Run the application
CMD [ "./photoprism-app" ]
