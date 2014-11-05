Intro
=====

This project fixes a crash in Spotify 0.9.14.13.gba5645ad on OS X.
It appears that Spotify uses the SPMediaKeyTap project (https://github.com/nevyn/SPMediaKeyTap), but a category on NSObject has been forgotten. This project aim at injecting the missing category in the Spotify process. The "NSObject+SPInvocationGrabbing" category has been copied from the original project. It is compiled, and a DYLD_INSERT_LIBRARIES variable is inserted into the environment variables of Spotify, directly in its Info.plist file.

Installing
==========

In order to install the fix, you need to download and install Xcode from the Mac App Store. Once done, please install the Xcode Command Line tools with the command:
`xcode-select --install`

Download the zip file from there, or clone the repository with:
`git clone https://github.com/bSr43/spotifix.git`

Finally, execute the command:
`make install`

If you need to uninstall the fix, you can execute the command:
`make uninstall`

