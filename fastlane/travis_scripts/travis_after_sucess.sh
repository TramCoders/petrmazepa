if [ "{$TRAVIS_BRANCH}" == "develop" ]; then
	fastlane ios report_test_coverage
fi