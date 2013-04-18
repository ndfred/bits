#!/bin/sh -ex

VERSION=`agvtool what-version -terse`

cd `dirname $0`
rm -rf build
[ ! -f Resources/Info.plist.bak ] && cp Resources/Info.plist Resources/Info.plist.bak
/usr/libexec/PlistBuddy -c "Add :TPTRevision string \"`git rev-parse HEAD`\"" Resources/Info.plist
xcodebuild -configuration Release -sdk iphoneos SYMROOT=build
mv Resources/Info.plist.bak Resources/Info.plist
xcrun -sdk iphoneos PackageApplication -v "$PWD/build/Release-iphoneos/Bits.app" -o "$PWD/build/Release-iphoneos/Bits-$VERSION.ipa"
cd "$PWD/build/Release-iphoneos"
zip -r9y Bits-$VERSION.app.dSYM.zip Bits.app.dSYM
echo "Your build is now ready: build/Release-iphoneos/Bits-$VERSION.ipa"
