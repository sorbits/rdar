// Tracking ID: <rdar://13113981>, filed 2013-01-30
#import <Cocoa/Cocoa.h>

int main (int argc, char const* argv[])
{
	@autoreleasepool {
		NSArray* paths = @[ @"/tmp", @"/etc" ];

		NSPasteboard* pboard = [NSPasteboard generalPasteboard];
		[pboard declareTypes:@[ NSFilenamesPboardType ] owner:nil];
		[pboard setPropertyList:paths forType:NSFilenamesPboardType];

		for(NSString* path in [pboard availableTypeFromArray:@[ NSFilenamesPboardType ]] ? [pboard propertyListForType:NSFilenamesPboardType] : nil)
			NSLog(@"%@", path);
	}
	return 0;
}
