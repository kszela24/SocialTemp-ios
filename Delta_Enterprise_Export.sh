#!/bin/bash
# original source from http://www.thecave.com/2014/09/16/using-xcodebuild-to-export-a-ipa-from-an-archive/

xcodebuild clean -project SocialTemp-ios -configuration Release -alltargets
xcodebuild archive -project SocialTemp-ios.xcodeproj -scheme SocialTemp-ios -archivePath SocialTemp-ios.xcarchive
xcodebuild -exportArchive -archivePath SocialTemp-ios.xcarchive -exportPath SocialTemp-ios -exportFormat ipa -exportProvisioningProfile "Delta"
