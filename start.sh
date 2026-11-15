#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

port="${1:-8091}"
image=localhost/course-site:v1
container=podman-lessons-site

if ! command -v podman >/dev/null; then
  printf '%s\n' 'Для запуска нужен Podman. Установка на Fedora описана в README.md.' >&2
  exit 1
fi

if podman container exists "$container"; then
  printf 'Контейнер %s уже существует. Откройте адрес из podman port %s или сначала остановите запущенный контейнер.\n' "$container" "$container" >&2
  exit 1
fi

podman build --pull=missing -t "$image" -f Containerfile .
podman run --pull=never --rm -d --name "$container" -p "127.0.0.1:$port:80" "$image"
printf 'Откройте в браузере http://127.0.0.1:%s/\n' "$port"
