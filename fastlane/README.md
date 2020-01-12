fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
### ana
```
fastlane ana
```
Hello
### pods
```
fastlane pods
```
Install dependencies via cocoaPods
### carth
```
fastlane carth
```
Install dependencies via carthage
### test
```
fastlane test
```
Runs all the tests
### coverage
```
fastlane coverage
```
Run test coverage
### lint
```
fastlane lint
```
Run SwiftLint analyze tool
### count
```
fastlane count
```
Run Cloc analyze tool
### build
```
fastlane build
```
Run building process

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
