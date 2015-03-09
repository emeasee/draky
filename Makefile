setup:
	npm install
	bower install --allow-root

dev:
	gulp browser-sync

build:
	gulp build

run:
	npm install
	bower install --allow-root
	gulp build
	http-server -p 8080 build/
