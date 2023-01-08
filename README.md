# Docker related files for the shoe lacing package

Tested functional with plautils v0.5.8.

## Usage
1. Clone plautils and build its image:
```
docker build -t planutils:latest . 
```
2. Clone this repo and build:
```
make build
```
3. Start the service by running:
```
make run
```