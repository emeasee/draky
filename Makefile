setup:
	npm install
	bower install --allow-root

run:
	gulp browser-sync

build:
	gulp build

deploy:
	gulp build
	http-server build/
