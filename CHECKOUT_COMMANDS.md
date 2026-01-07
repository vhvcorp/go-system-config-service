# Git Checkout Commands

## For existing repository

If you already have the repository cloned, use this command to checkout the new branch:

```bash
git fetch origin
git checkout copilot/update-repository-structure
```

## For new clone

If you're cloning the repository for the first time, use these commands:

```bash
# Clone the repository
git clone https://github.com/vhvplatform/go-system-config-service.git
cd go-system-config-service

# Checkout the new branch
git checkout copilot/update-repository-structure
```

## Repository Structure

After checking out the branch, you'll see the following structure:

```
.
├── server/          # Golang backend microservice
├── client/          # ReactJS frontend microservice
├── flutter/         # Flutter mobile application
└── docs/            # Project documentation
```

## Verification

To verify the structure is correct:

```bash
# List the main directories
ls -la

# Verify the server can build
cd server
go build ./cmd/main.go
```
