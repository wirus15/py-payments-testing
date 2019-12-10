run_wiremock:
	cd src/main/resources && java -jar wiremock-standalone-2.21.0.jar -https-port 8443 -verbose
