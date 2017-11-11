hugo-serve:
	hugo serve -b http://localhost:1313/engineering-records
deploy:
	hugo && s3cmd sync -r ./public/* s3://blog.velvetreactor.com --delete-removed
