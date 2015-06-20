#!/bin/sh
clear
app="${HOME}/Applications/rattleCAD.app"
cd $(dirname $0)
version=$(basename $PWD)
read -p "Press any key to install $PWD to ${app}..."

python2.7 -m bundlebuilder \
	--name=rattleCAD \
	--bundle-id=net.sourceforge.rattleCAD \
	--builddir=$HOME/Applications \
	--executable=/System/Library/Frameworks/Tk.framework/Versions/Current/Resources/Wish.app/Contents/MacOS/Wish \
	--file=./:Contents/Resources/Scripts \
	--iconfile=rattleCAD.icns \
	build

plutil -replace CFBundleShortVersionString -string "$version" $app/Contents/Info.plist 
plutil -replace CFBundleVersion -string "0.0.0" $app/Contents/Info.plist
plutil -replace NSHumanReadableCopyright -string "built $(date) by $(id -F)" $app/Contents/Info.plist
plutil -replace NSSupportsAutomaticTermination -bool true $app/Contents/Info.plist
plutil -replace NSSupportsSuddenTermination -bool true $app/Contents/Info.plist

open -R $app
read -p "All done! Press any key to close this script window..."
