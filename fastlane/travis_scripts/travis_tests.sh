if [ "$TRAVIS_PULL_REQUEST" != "false" ] ||  [ "{$TRAVIS_BRANCH}" = "develop" ]; then
	fastlane test
	exit $?
fi