SHELL=/usr/bin/sh
MAKEFLAGS += --silent

.PHONY: run

run:
	JEKYLL_ENV=development bundle exec jekyll serve \
			--future \
			--unpublished \
			--host \
			--trace \
			--livereload

deploy: build upload

deep-clean:
	echo Removing .vendor directory
	rm -rf .vendor
	echo Removing _site directory
	rm -rf _site
	echo Removing .sass-cache directory
	rm -rf .sass-cache

clean:
	bundle exec jekyll clean --trace

build:
	JEKYLL_ENV=production bundle exec jekyll build --trace
	dunstify "Build done" -t 60000 -r 1234 -u critical
	tree _site -C -d | sed 's/^/                    /'

upload: build
	echo Start upload
	#scp -r _site/* skolavprirode:~/public_html/
	rsync -varhIu --progress --delete _site/ skolavprirode:~/public_html/
	echo End upload

install:
	gem install bundler
	bundle config set --local path '.vendor/bundle'
	bundle install

profile:
	bundle exec jekyll build --profile --trace

update:
	bundle update
	bundle update --bundler
	bundle install
