if [ "{$TRAVIS_BRANCH}" == "develop" ]; then
	fastlane ios report_tests_failed
fi