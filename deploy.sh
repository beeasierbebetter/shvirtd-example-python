#!/usr/bin/env bash

set -Eeuo pipefail

readonly REPO_URL="https://github.com/beeasierbebetter/shvirtd-example-python.git"
readonly APP_DIR="/opt/shvirtd-example-python"

if [[ "${EUID}" -ne 0 ]]; then
  echo "Ошибка: запустите скрипт через sudo."
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  echo "Ошибка: git не установлен."
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Ошибка: Docker не установлен."
  exit 1
fi

if [[ -d "${APP_DIR}/.git" ]]; then
  echo "Репозиторий уже существует. Получаем обновления..."
  git -C "${APP_DIR}" pull --ff-only
elif [[ -e "${APP_DIR}" ]]; then
  echo "Ошибка: ${APP_DIR} существует, но не является Git-репозиторием."
  exit 1
else
  echo "Клонируем репозиторий в ${APP_DIR}..."
  git clone "${REPO_URL}" "${APP_DIR}"
fi

cd "${APP_DIR}"

echo "Запускаем проект..."
docker compose up -d --build

echo "Состояние сервисов:"
docker compose ps
