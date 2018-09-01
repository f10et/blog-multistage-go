#
# BUILD STAGE
# 
FROM golang:1.10 AS build

# Setting the working directory of our application
WORKDIR /go/src/github.com/scboffspring/blog-multistage-go

# Adding all the files required to compile the application
ADD . .

# Compiling a static go application (include C libraries in the built binary)
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo .

# Set the startup command to be our application
CMD ["./blog-multistage-go"]


# 
# CERTS Stage
#
FROM alpine:latest as certs

# Install the CA certificates
RUN apk --update add ca-certificates

#
# PRODUCTION STAGE
# 
FROM scratch AS prod

# Copy the CA certificate from the certs stage
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
# Copy the binary built during the build stage
COPY --from=build /go/src/github.com/scboffspring/blog-multistage-go/blog-multistage-go .
CMD ["./blog-multistage-go"]
