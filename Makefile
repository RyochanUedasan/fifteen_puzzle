pre-push: fmt analyze .test

analyze:
	flutter analyze

.test:
	flutter test

fmt:
	flutter format lib test
