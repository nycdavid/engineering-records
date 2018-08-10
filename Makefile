dev:
	hugo serve
deploy:
	hugo && s3cmd sync -r ./public/* s3://www.velvetreactor.com --delete-removed
