#!/bin/bash
set -e

# allow the container to be started with `--user`
if [[ "$*" == node*current/index.js* ]] && [ "$(id -u)" = '0' ]; then
	chown -R node "$GHOST_CONTENT"
	exec su-exec node "$BASH_SOURCE" "$@"
fi

if [[ "$*" == node*current/index.js* ]]; then
	baseDir="$GHOST_INSTALL/content.orig"
	for src in "$baseDir"/*/ "$baseDir"/themes/*; do
		src="${src%/}"
		target="$GHOST_CONTENT/${src#$baseDir/}"
		mkdir -p "$(dirname "$target")"
		if [ ! -e "$target" ]; then
			tar -cC "$(dirname "$src")" "$(basename "$src")" | tar -xC "$(dirname "$target")"
		fi
	done

	# symlink our config to the content directory so we can update it
	mv "$GHOST_INSTALL/config.production.json" "$GHOST_CONTENT/config.production.json"
	ln -s "$GHOST_CONTENT/config.production.json" "$GHOST_INSTALL/config.production.json"

	knex-migrator-migrate --init --mgpath "$GHOST_INSTALL/current"
fi

exec "$@"
