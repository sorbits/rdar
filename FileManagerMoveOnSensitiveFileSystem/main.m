// Tracking ID: <rdar://13161552>, filed 2013-02-06
#import <Foundation/Foundation.h>

int main (int argc, char const* argv[])
{
    @autoreleasepool {
        NSFileManager* fm = [NSFileManager defaultManager];
        NSError* error    = nil;
        NSURL* srcURL     = [NSURL fileURLWithPath:@"/Volumes/test/untitled.txt"];
        NSURL* dstURL     = [NSURL fileURLWithPath:@"/Volumes/test/Untitled.txt"];

        if([fm moveItemAtURL:srcURL toURL:dstURL error:&error])
            return 0;

        NSLog(@"%@", error);
    }
    return -1;
}
