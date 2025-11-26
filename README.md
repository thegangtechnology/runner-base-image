# TG Custom Github Runner Image

This image pre-installed common package that The Gang uses to reduce the overall runner time.

## Language Target
- Ruby on Rails
- Django

## Build and push on Mac

You need to auth with github first
### Auth
```
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
```

### Push
```
docker buildx build --platform linux/amd64 -t ghcr.io/thegangtechnology/runner-base-image/tg-runner-image:latest --push .
```