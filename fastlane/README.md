fastlane documentation
================
# Installation
```
sudo gem install fastlane
```
# Available Actions
## Mac
### mac xcode
```
fastlane mac xcode
```
Installs xcode plugin FixCode to prevent xcode from automatically 'Fixing issues' with code signing

----

## iOS
### ios badge
```
fastlane ios badge
```
Submit a new development version for internal testing

This action does the following:



- 1) Ensures a clean git status

- 2) Increment the build number

- 3) Increment the version number, if option included

- 4) Get our mobile provisioning profile

- 5) Build and sign the app

- 6) Upload the ipa file to TestFlight

- 7) Commit the version bump

- Post a message to slack whether success or failure
### ios internal
```
fastlane ios internal
```

### ios testflight
```
fastlane ios testflight
```

### ios production
```
fastlane ios production
```
Deploy a new version to the App Store

----

This README.md is auto-generated and will be re-generated every time to run [fastlane](https://fastlane.tools).
More information about fastlane can be found on [https://fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [GitHub](https://github.com/fastlane/fastlane/tree/master/fastlane).