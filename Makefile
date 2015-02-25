setup:
	npm install
	npm install -g bower
	bower install --allow-root

run:
	gulp browser-sync

build:
	gulp build

deploy:
	gulp build
	http-server -p 80 build/
