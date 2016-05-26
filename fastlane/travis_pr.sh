if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
	fastlane ios test
	exit $?
fi
