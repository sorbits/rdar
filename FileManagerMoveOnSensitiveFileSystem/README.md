# Summary

Using NSFileManager to rename a file, only making case changes, on a HFS+ non-sensitive file system fails.

# Steps to Reproduce

Compile and run [`main.m`](main.m):

	# Create a disk image with non-sensitive file system
	hdiutil create -size 1m -type UDIF -fs JHFS+ -volname "test" -ov -attach "$TMPDIR/test.dmg"
	
	# Create file on disk image with lowercased name
	touch /Volumes/test/untitled.txt
	
	# Build and run our test program
	clang -framework Foundation -o /tmp/main.exe main.m
	/tmp/main.exe
	
	# Check that file has been renamed
	ls -l /Volumes/test

# Expected Result

File is renamed to capitalized `Untitled.txt` and shown by `ls -l`.

# Actual Result

Move fails with this error:

	main.exe: Error Domain=NSCocoaErrorDomain Code=516 "“untitled.txt” couldn’t be moved to “test” because an item with the same name already exists." UserInfo=0x7f96e9c105a0 {
		NSSourceFilePathErrorKey=/Volumes/test/untitled.txt,
		NSUserStringVariant=(
	    	Move
		),
		NSDestinationFilePath=/Volumes/test/Untitled.txt,
		NSFilePath=/Volumes/test/untitled.txt,
		NSUnderlyingError=0x7f96e9c103a0 "The operation couldn’t be completed. File exists"
	}
