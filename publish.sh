#!/bin/sh

set -e

if [ -z "$PAGES_DEPLOY_DEST" ]; then
  echo "\033[1;37mError:$1\033[0m Must set \$PAGES_DEPLOY_DEST" >&2
  exit 1
fi

if pgrep --full 'jekyll s' >/dev/null; then
  echo "\033[1;37mCheck Failed:$1\033[0m jekyll serve is running" >&2
  exit 1
fi

bundle exec jekyll build
rsync -rv _site/ "$PAGES_DEPLOY_DEST"
