#Welcome Leo iOS Developers!


##Useful info for New Employees


####Technical Account Requirements

You'll need access to the following accounts as a new employee. Your manager should have set these up for you before you arrive. Go through your email and make sure any that you have accepted any invites that are required in order to get access to these resources. These include:

* Private github repo access
* Slack
* iTunesConnect


####Installation

* [Cocoapods](www.cocoapods.org)
You'll need to setup cocoapods to add all of our third party dependencies.

* Elastic Beanstalk
Talk to your manager when you arrive about getting access to elastic beanstalk.

* Apple Developer Certificates
You'll need access to a developer certificate. Talk to your manager. *Please do not allow Apple to automatically `Fix issue` from Xcode and provide you with new certificates.*

* Launching the App
Please use the `Leo.xcworkspace` file to open the project.


##Uploading a build to iTunesConnect
We use [fastlane](https://fastlane.tools/)! Currently our only build function is for alpha builds that automatically get pushed to internal Testflight users. To push a new build:


`fastlane ios alpha`


Soon we will implement further fastlane capabilities to launch a production app. We will update this file when that functionality is complete.


##Style guide

For the time being, until we have an opportunity to develop our own style guide, let's stick with the standards per the [New York Times](https://github.com/NYTimes/objective-c-style-guide). As questions arise over time, we may choose to amend sections and these will be laid out here explicitly.


##Tools

[Alcatraz](http://www.alcatraz.io)



##Resources


####Books
[Clean Code by Uncle Bob](http://amzn.com/0132350882)

[Objective-C 2.0](http://amzn.com/0321917014)


####Videos
[WWDC Videos](https://developer.apple.com/videos/wwdc2015/)


####Websites
[objc.io](http://www.objc.io)

