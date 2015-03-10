setup:
	npm install
	bower install --allow-root

dev:
	gulp browser-sync

build:
	gulp build
