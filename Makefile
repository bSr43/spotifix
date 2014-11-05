SPOTIFY_PATH=/Applications/Spotify.app
SPOTIFY_PLIST=$(SPOTIFY_PATH)/Contents/Info.plist
LSREGISTER=/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister

libspotifix.dylib: libspotifix-32.dylib libspotifix-64.dylib
	lipo -create -arch i386 libspotifix-32.dylib -arch x86_64 libspotifix-64.dylib -output libspotifix.dylib

libspotifix-32.dylib: NSObject+SPInvocationGrabbing-32.o
	clang -o $@ $^ -shared -framework Cocoa -arch i386

libspotifix-64.dylib: NSObject+SPInvocationGrabbing-64.o
	clang -o $@ $^ -shared -framework Cocoa -arch x86_64

%-32.o: %.m
	clang -c -o $@ $^ -arch i386

%-64.o: %.m
	clang -c -o $@ $^ -arch x86_64

.PHONY: clean
clean:
	rm -f *.o libspotifix*.dylib

.PHONY: install
install: libspotifix.dylib
	cp libspotifix.dylib "$(SPOTIFY_PATH)/Contents/MacOS"
	awk '/ATSApplicationFontsPath/ { print "\t<key>LSEnvironment</key>\n\t<dict>\n\t\t<key>DYLD_INSERT_LIBRARIES</key>\n\t\t<string>$(SPOTIFY_PATH)/Contents/MacOS/libspotifix.dylib</string>\n\t</dict>" }; { print $0 };' "$(SPOTIFY_PLIST)" >"$(SPOTIFY_PLIST).new"
	rm -f "$(SPOTIFY_PLIST)"
	mv "$(SPOTIFY_PLIST).new" "$(SPOTIFY_PLIST)"
	$(LSREGISTER) -v -f "$(SPOTIFY_PATH)"

.PHONY: uninstall
uninstall:
	rm -f "$(SPOTIFY_PATH)/Contents/MacOS/libspotifix.dylib"
	awk 'BEGIN { IN_ENV=0 }; /LSEnvironment/ { IN_ENV = 1 }; IN_ENV==0 { print $0 }; IN_ENV==1 && /<\/dict>/ { IN_ENV=0 };' "$(SPOTIFY_PLIST)" >"$(SPOTIFY_PLIST).new"
	rm -f "$(SPOTIFY_PLIST)"
	mv "$(SPOTIFY_PLIST).new" "$(SPOTIFY_PLIST)"
	$(LSREGISTER) -v -f "$(SPOTIFY_PATH)"
