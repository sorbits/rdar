// Tracking ID: <rdar://13187087>, filed 2013-02-09
#include <ApplicationServices/ApplicationServices.h>
#include <cstdio>
#include <map>
#include <string>

int main (int argc, char const* argv[])
{
	std::map<std::string, size_t> duplicateCount;

	if(CFURLRef url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, CFSTR("/Library/Documentation/iCloud_Terms_and_Conditions.txt"), kCFURLPOSIXPathStyle, false))
	{
		if(CFArrayRef array = LSCopyApplicationURLsForURL(url, kLSRolesAll))
		{
			for(CFIndex i = 0; i < CFArrayGetCount(array); ++i)
			{
				CFURLRef appURL = (CFURLRef)CFArrayGetValueAtIndex(array, i);
				if(CFStringRef path = CFURLCopyFileSystemPath(appURL, kCFURLPOSIXPathStyle))
				{
					CFIndex byteCount;
					CFStringGetBytes(path, CFRangeMake(0, CFStringGetLength(path)), kCFStringEncodingUTF8, 0, false, NULL, 0, &byteCount);
					std::string res(byteCount, ' ');
					CFStringGetBytes(path, CFRangeMake(0, CFStringGetLength(path)), kCFStringEncodingUTF8, 0, false, (UInt8*)&res[0], byteCount, NULL);

					duplicateCount[res]++;

					CFRelease(path);
				}
			}
			CFRelease(array);
		}
		CFRelease(url);
	}

	for(auto pair : duplicateCount)
	{
		if(pair.second > 1)
			fprintf(stdout, "Found %zu duplicates of %s\n", pair.second, pair.first.c_str());
	}

	return 0;
}
