.PHONY: help install dev build preview check clean reinstall

help:
	@echo "Comandos disponibles:"
	@echo "  make install    - Instala las dependencias con pnpm"
	@echo "  make dev        - Arranca el servidor de desarrollo"
	@echo "  make build      - Genera el build de producción en dist/"
	@echo "  make preview    - Sirve el build de producción localmente"
	@echo "  make check      - Verifica tipos y errores con astro check"
	@echo "  make clean      - Elimina dist/ y .astro/"
	@echo "  make reinstall  - Reinstala las dependencias desde cero"

install:
	pnpm install

dev:
	pnpm dev

build:
	pnpm build

preview:
	pnpm preview

check:
	pnpm check

clean:
	rm -rf dist .astro

reinstall:
	rm -rf node_modules pnpm-lock.yaml
	pnpm install
