# Continuously Mac: iOS App

Continuously Mac is a news aggregator Angular webapp dedicated to finding you the latest apple news from the very best Tech Journalists.

No complex categories, just a simple list of great Apple news.

## Features

* The latest apple news from the very best Tech Journalists.
* Articles are collected from a [dedicated API](https://github.com/steven-martin/continuously-mac-api), which is updated every 15 minutes.

## Quick Start

Download this repo locally and open it in Xcode. Xcode will be able to provide you with all of the tools you need to run, build and test this App. 

> If you wish to run both the iOS App and the API locally then you will need to install the [Continuously Mac API](https://github.com/steven-martin/continuously-mac-api) and update the API url from within the code. The API url is documented in Services/ContinuouslyMacAPI.Client.swift.


## Deployment to App Store

Once you have finsihed developing the App and want to deployed it to the App Store.

> If you are creating a new App for the first time it's recommended that you look online for instrcutions on how to do the following.

Validate your existing bundle on developer.apple.com or create a new bundle
* Visit: developer.apple.com -> Certificates, Identifiers & Profiles
* Ensure you have a valid Bundle ID within the section: Identifiers -> App IDs

> If the App is not set up on App Store Connect you will need to visit: https://appstoreconnect.apple.com/ and create a new iOS App using your Bundle ID and a unique SKU number)

Provision our Development and Distribution Profiles
* Visit: developer.apple.com -> Certificates, Identifiers & Profiles
* Ensure you have a valid Developer and Distribution Profile within the section: Identifiers -> Provisioning Profiles
* If either your Developer Profile or Distribution Profile is missing or out of date you will need to recreate, download and install it.

> Please ensure you're signed into your apple account within Xcode (Menu -> Xcode -> Preferences -> Account) before attempting the following steps

Setup the App's properties with the correct certificates and profiles
* In Xcode go to: ContinuouslyMac -> General
* Validate the version number, build and Bundle Identifier is correct
* Archive the App: Menu -> Product -> Archive
* The Archive window will appear with your new archive added
* Click the 'Upload to App Store' / 'Distribute App' button
* Select method of distribution: 'iOS App Store' and 'Upload'
* Select all of the distribution options and automatic signing
* Once the App has been successfully uploaded to the App Store return to App Store Connect and review the new version.
* The new version should appear with the status of 'Processing' on App Store Connect: My Apps -> All Builds -> Activity
* Once the new version has finsihed 'Processing' (which can take a number of hours) the build will be available on App Store Connect
* You can now create a new version of the App on App Store Connect, enter the Apps details and Submit it for Review.

