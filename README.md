# What is this?

This is a Dockerfile which to generate a Docker image running the Ghost blog on an alpine linux image with accessible config.

This has been adapted from the [Git repo of the Docker official image](https://github.com/docker-library/ghost) (specifically [this Dockerfile](https://github.com/docker-library/ghost/blob/master/1/alpine/Dockerfile)), as we want to expose the configuration as well as the content.

We do this in `docker-entrypoint.sh` by:

* moving `/var/lib/ghost/config.production.json` to `/var/lib/ghost/content/config.production.json`
* and then symlinking `/var/lib/ghost/config.production.json` to `/var/lib/ghost/content/config.production.json`

Building:

	 docker build -t mebooks/docker-ghost-alpine .

Running:

	# Visit the site at http://localhost:3001
	docker run -d \
		--name ghost \
		-p 3001:2368 \
		-v /path/to/ghost/blog:/var/lib/ghost/content \
		mebooks/docker-ghost-alpine:latest

	# Run a bash shell in the container
	docker exec -it ghost /bin/bash
