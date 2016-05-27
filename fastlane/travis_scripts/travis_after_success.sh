
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
	fastlane ios report_pr_test_passed
	exit $?
fi

if [[ "$TRAVIS_BRANCH" == "develop" ]]; then
	fastlane ios report_test_coverage
	exit $?
fi