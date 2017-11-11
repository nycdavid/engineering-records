### Dependencies
* Hugo `brew install hugo`
* s3cmd (for deployments) `brew install s3cmd`

### Deploying
* First run `s3cmd --configure` to ensure all the credentials have been set properly.
* Use the Makefile command `make deploy`
