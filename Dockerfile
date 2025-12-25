# Build stage
FROM golang:1.25-alpine AS builder

WORKDIR /app

# Copy go mod files
COPY go.work go.work
COPY pkg/go.mod pkg/go.sum ./pkg/
COPY services/system-config-service/go.mod services/system-config-service/go.sum ./services/system-config-service/

# Download dependencies
RUN cd services/system-config-service && go mod download

# Copy source code
COPY pkg/ ./pkg/
COPY services/system-config-service/ ./services/system-config-service/

# Build the service
RUN cd services/system-config-service && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /app/bin/system-config-service ./cmd/main.go

# Runtime stage
FROM alpine:latest

RUN apk --no-cache add ca-certificates tzdata

WORKDIR /root/

# Copy binary from builder
COPY --from=builder /app/bin/system-config-service .

# Expose ports
EXPOSE 8085 50055

# Run the service
CMD ["./system-config-service"]
