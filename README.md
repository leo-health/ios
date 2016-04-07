#Welcome Leo iOS Developers!


##Useful info for New Employees


####Technical Account Requirements

You'll need access to the following accounts as a new employee. Your team should have set these up for you before you arrive. Go through your email and make sure any that you have accepted any invites that are required in order to get access to these resources. These include:

* Private github repo access
* Slack
* iTunesConnect


####Installation

* [Cocoapods](www.cocoapods.org)
You'll need to setup cocoapods to add all of our third party dependencies.

* Elastic Beanstalk
Talk to your team when you arrive about getting access to elastic beanstalk.

* Apple Developer Certificates
You'll need access to a developer certificate. Talk to your team and they will get you setup. *Please do not allow Apple to automatically `Fix issue` from Xcode and provide you with new certificates.*

* Install fastlane
Install [fastlane](https://fastlane.tools/) using the following command.
```sudo gem install fastlane --verbose```

* Install Required Xcode Plugins
Run the following command from the terminal after installing fastlane.
```fastlane mac xcode```

* Launching the App
Please use the `Leo.xcworkspace` file to open the project.

####[CHANGELOG.yml](CHANGELOG.yml)

* Found in the base directory, you may wish to peruse [CHANGELOG.yml](CHANGELOG.yml) to see what has changed since the last build. It contains a history of all builds pushed to iTunesConnect and a summary of the differences between them.

##Uploading a build to iTunesConnect

####**Rules you must follow. Read this BEFORE reading on.**

For the time-being as we develop our automated build capabilities, there are certain procedures you MUST follow to keep things clean. These are as follows:

* Builds should only be created off of master. And master should be even with our repo on github, not ahead or behind in commits.

* Before creating a build, update the [CHANGELOG.yml](CHANGELOG.yml) with a bulleted list under `upcoming` that describes the changes since the prior build in a lay-friendly way. Use english, not engineerish.

* Commit this change with the message `NI - CHANGELOG: Pre-build update`

* Upload the build (see below directions on how to do this) and then **HANDS OFF** until you see that the build has properly uploaded (~2 minutes or less). This eventually will not be necessary but with the current in-process automation, it is important for cleanliness of our repos against our builds.

* Commit the changes once the build completes with the message `NI - CHANGELOG: Post-build update`.

* This is the one time you are allowed to push directly to master. Do so now!

* You must have the necessary private keys on your local machine. Ask someone for them if you need them. They should sit in a folder called `private_keys` at the same level as your project directory (to be clear, not in your project directory).

* You must, for the time-being, manually upload a zipped dsym to Crittercism. The script for crittercism dsym uploads works in development but does not yet work in production. Once this has been updated, we will remove this step. Instructions for doing this can be found on Crittercism's website. If you do not have a login for Crittercism, ask for one if you are responsible for uploading builds to iTunesConnect.

####Uploading the Build

Did you read the **Rules you must follow** section? If not, read that before reading this! We use [fastlane](https://fastlane.tools/)! Currently we support two builds -- `internal`, which may be distributed internally, and `testflight` which may be distributed externally to testers. In order to upload a build, after installing fastlane on your machine you may type `fastlane ios <lane>` where `<lane>` is either `internal` or `testflight`

```
fastlane ios internal
```

If building for an external testflight release, the build should be bumped. This may be done by adding the bump_type argument to the terminal command. Options are `patch`, `minor`, and `major`.

```
fastlane ios testflight bump_type:minor
```
Soon we will implement further fastlane capabilities to launch a production app. We will update this file when that functionality is complete.

Finally, make sure to push git tags to the server after deploying a new build.

##Coding style guide

For the time being, until we have an opportunity to develop our own style guide, let's stick with the standards per the [New York Times](https://github.com/NYTimes/objective-c-style-guide). As questions arise over time, we may choose to amend sections and these will be laid out here explicitly.

##Git style guide

* We are currently somewhere between git-flow and github-flow.


* We do not use a development branch, but private integration branches are encouraged.


* Work should be committed to a fork, and then a pull request made to submit changes.


* Changes from master should be rebased into the branch, and changes from the remote should always be rebased into master. Rebase down! Merge up!


* Commit messages are ideally styled as such:

```
> git commit -m "<issue number> - <commit type>: <detail of commit, in present tense>"
```

Issue numbers may be chained together via underscores when necessary, e.g.

```
> git commit -m "298_299_567 - Feature: Menu button placement and sizing"
```

Commit types may also be chained together with the backslash, e.g.

```
> git commit -m "529 - Refactor/Fix: Signing up and editing of patients via LEOSignUpPatientViewController and LEOSignUpPatientView and associated classes."
```

Standard commit types you will see include:
* **Refactor** - Cleaning up of code, removing dependencies, updating pods.

* **Feature** - If it has not been considered yet, it is a feature, even if it's lack of consideration to date manifests itself in bugs!

* **Fix** - Changes based on feedback

* **NI** - Only used for builds and readme updates regularly. Should be used sparingly otherwise. Stands for `No Issue`.

* **Pull Request Code Review** - Used for `issues` that are actually pull requests when the feedback does not result in its own issues being created but rather changes made directly to the pull request based on the feedback. When this commit type is used, please use the pull request number to reflect the issue. Do not re-use the issue number of one of the commits within the pull request. Detailed commenting here is not required as it often exceeds a reasonable length and can easily be reviewed in context using the pull request itself.

* You may see other options going back further in the history. Let's not get caught up with old ways of doing things. Changes and amendments to this style will be made as necessary and this is always open to discussion if you think you have something to add!


##Xcode preferences

* Spaces, not tabs
* Automatically trim trailing whitespace, including white-space only lines

##Tools

#####[Alcatraz](http://www.alcatraz.io)

* AdjustFontSize
* BBUFullIssueNavigator
* ClangFormat
* ColorSenseRainbow
* Jumper
* KSImageNamed
* Polychromatic (personal favorite, not required!)
* VVDocumenter-Xcode
* XCommentWrap (not currently using, but good practice)
* Quick Templates
* Specta Templates


#####[Fastlane](http://www.fastlane.tools)

_Tools currently in-use, excluding macros:_

* Gym
* Pilot
* Sigh


#####[Cocoapods](http://www.cocoapods.org)

_All pods used are MIT Licensed at this time._

* AFNetworking
* ActionSheetPicker-3.0 (Deprecated - Will be removed soon.)
* DateTools
* JSQMessagesViewController
* libPusher
* MBProgressHUD
* OHHTTPStubs
* RSKImageCropper
* SSKeychain
* TPKeyboardAvoiding
* UIImage-Resize
* VBFPopFlatButton


##Resources


####Books
######[Clean Code by Uncle Bob](http://amzn.com/0132350882)
######[Objective-C 2.0](http://amzn.com/0321917014)
######[Functional Swift](https://www.objc.io/books/functional-swift/)
######[Advanced Swift](https://www.objc.io/books/advanced-swift/)*

*We have a copy of this in house.

####Videos
######[WWDC Videos](https://developer.apple.com/videos/wwdc2015/)


####Websites
######[objc.io](http://www.objc.io)
######[iOS Good Practices](https://github.com/futurice/ios-good-practices)
######[NSHipster](http://www.nshipster.com)
######[NatashaTheRobot](http://natashatherobot.com/)
######[iOSDevWeekly](https://iosdevweekly.com/)
