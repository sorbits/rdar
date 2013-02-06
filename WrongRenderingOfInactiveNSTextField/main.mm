// Tracking ID: <rdar://13161778>, filed 2013-02-06
#import <Cocoa/Cocoa.h>

@interface MyView : NSView
@property (nonatomic, getter = isOpaque) BOOL opaque;
@end

@implementation MyView
- (id)initWithFrame:(NSRect)aRect
{
	if(self = [super initWithFrame:aRect])
	{
		NSTextField* textField = [[NSTextField alloc] initWithFrame:NSZeroRect];
		textField.bezeled         = NO;
		textField.bordered        = NO;
		textField.drawsBackground = NO;
		textField.editable        = NO;
		textField.selectable      = NO;
		textField.stringValue     = @"Hello world.";
		[[textField cell] setBackgroundStyle:NSBackgroundStyleRaised];

		[textField setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:textField];

		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textField]-|" options:0 metrics:nil views:@{ @"textField" : textField }]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textField]-|" options:0 metrics:nil views:@{ @"textField" : textField }]];
	}
	return self;
}

- (void)drawRect:(NSRect)aRect
{
	NSGradient* gradient = [[NSGradient alloc] initWithStartingColor:[NSColor darkGrayColor] endingColor:[NSColor lightGrayColor]];
	[gradient drawInRect:self.bounds angle:90];
}
@end

int main (int argc, char const* argv[])
{
  	@autoreleasepool {
    	[NSApplication sharedApplication];
    	[NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
    	[NSApp activateIgnoringOtherApps:YES];

    	NSMenu* appMenu = [NSMenu new];
    	[appMenu addItem:[[NSMenuItem alloc] initWithTitle:@"Quit TestApp" action:@selector(terminate:) keyEquivalent:@"q"]];

    	NSMenuItem* appMenuItem = [NSMenuItem new];
    	[appMenuItem setSubmenu:appMenu];

    	NSMenu* mainMenu = [NSMenu new];
    	[mainMenu addItem:appMenuItem];
    	[NSApp setMainMenu:mainMenu];

    	NSWindow* window = [[NSWindow alloc] initWithContentRect:NSZeroRect styleMask:(NSTitledWindowMask|NSClosableWindowMask|NSResizableWindowMask|NSMiniaturizableWindowMask|NSTexturedBackgroundWindowMask) backing:NSBackingStoreBuffered defer:NO];
    	[window setTitle:@"TestApp"];

        MyView* normalView = [[MyView alloc] initWithFrame:NSZeroRect];
        MyView* opaqueView = [[MyView alloc] initWithFrame:NSZeroRect];
        opaqueView.opaque = YES;

        NSDictionary* views = @{
            @"normalView" : normalView,
            @"opaqueView" : opaqueView,
        };

		for(NSView* view in [views allValues])
		{
			[view setTranslatesAutoresizingMaskIntoConstraints:NO];
			[window.contentView addSubview:view];
		}

        [window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[normalView]-[opaqueView]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
		[window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[normalView]-|" options:0 metrics:nil views:views]];

    	[window makeKeyAndOrderFront:nil];
    	[window center];

    	[NSApp run];
	}
	return 0;
}
