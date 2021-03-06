#!/bin/bash

set -e


# xcodebuild -showsdks

cd framework
xcodebuild -project GPUImage.xcodeproj -target GPUImage -configuration Release -sdk iphoneos build
xcodebuild -project GPUImage.xcodeproj -target GPUImage -configuration Release -sdk iphonesimulator build
cd ..

cd build
# for the fat lib file
mkdir -p Release-iphone/lib
xcrun -sdk iphoneos lipo -create Release-iphoneos/libGPUImage.a Release-iphonesimulator/libGPUImage.a -output Release-iphone/lib/libGPUImage.a
xcrun -sdk iphoneos lipo -info Release-iphone/lib/libGPUImage.a
# for header files
mkdir -p Release-iphone/include
cp ../framework/Source/*.h Release-iphone/include
cp ../framework/Source/iOS/*.h Release-iphone/include

# Build static framework
mkdir -p GPUImage.framework/Versions/A
cp Release-iphone/lib/libGPUImage.a GPUImage.framework/Versions/A/GPUImage
mkdir -p GPUImage.framework/Versions/A/Headers
cp Release-iphone/include/*.h GPUImage.framework/Versions/A/Headers
ln -sfh A GPUImage.framework/Versions/Current
ln -sfh Versions/Current/GPUImage GPUImage.framework/GPUImage
ln -sfh Versions/Current/Headers GPUImage.framework/Headers

# 
mkdir -p ../../build/ios/include/GPUImage
cp Release-iphone/include/*.h ../../build/ios/include/GPUImage/
cp Release-iphone/lib/libGPUImage.a ../../build/ios/lib/