// Tracking ID: <rdar://13093498>, filed 2013-01-27
#import <Cocoa/Cocoa.h>

@interface MyView : NSView
@property (nonatomic) NSDictionary*   myViews;
@property (nonatomic) NSMutableArray* myConstraints;
@property (nonatomic) BOOL            verticalLayout;
@end

@implementation MyView
+ (BOOL)requiresConstraintBasedLayout
{
	return YES;
}

- (id)initWithFrame:(NSRect)aRect
{
	if(self = [super initWithFrame:aRect])
	{
		NSMutableDictionary* views = [NSMutableDictionary dictionary];
		self.myViews = views;
		self.myConstraints = [NSMutableArray new];

		for(NSString* key in @[ @"left", @"right", @"divider" ])
		{
			NSBox* view = [[NSBox alloc] initWithFrame:NSZeroRect];
			view.translatesAutoresizingMaskIntoConstraints = NO;
			view.boxType     = NSBoxCustom;
			view.borderType  = NSLineBorder;
			view.borderColor = [NSColor controlShadowColor];

			[self addSubview:view];
			views[key] = view;
		}

		[self setNeedsUpdateConstraints:YES];
	}
	return self;
}

- (void)updateConstraints
{
	[[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];

	[self removeConstraints:self.myConstraints];
	[super updateConstraints];
	[self.myConstraints removeAllObjects];

	if(self.verticalLayout)
	{
		[self.myConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[left(==100)]-[divider(==1)]-[right(==100)]-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:self.myViews]];
		[self.myConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[left(==right,==100)]-|" options:0 metrics:nil views:self.myViews]];
		[self.myConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[divider]|" options:0 metrics:nil views:self.myViews]];
	}
	else
	{
		[self.myConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[left(==100)]-[divider(==1)]-[right(==100)]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:self.myViews]];
		[self.myConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[left(==right,==100)]-|" options:0 metrics:nil views:self.myViews]];
		[self.myConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[divider]|" options:0 metrics:nil views:self.myViews]];
	}

	[self addConstraints:self.myConstraints];
}

- (void)mouseDown:(NSEvent*)anEvent
{
	self.verticalLayout = !self.verticalLayout;
	[self setNeedsUpdateConstraints:YES];
}
@end

static void OakSetupApplicationWithView (NSView* aView, NSString* appName = @"Untitled App")
{
	[NSApplication sharedApplication];
	[NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
	[NSApp activateIgnoringOtherApps:YES];

	NSMenu* appMenu = [NSMenu new];
	[appMenu addItem:[[NSMenuItem alloc] initWithTitle:[@"Quit " stringByAppendingString:appName] action:@selector(terminate:) keyEquivalent:@"q"]];

	NSMenuItem* appMenuItem = [NSMenuItem new];
	[appMenuItem setSubmenu:appMenu];

	NSMenu* mainMenu = [NSMenu new];
	[mainMenu addItem:appMenuItem];
	[NSApp setMainMenu:mainMenu];

	NSWindow* window = [[NSWindow alloc] initWithContentRect:NSZeroRect styleMask:NSTitledWindowMask|NSResizableWindowMask backing:NSBackingStoreBuffered defer:NO];
	[window setTitle:appName];
	[window setContentView:aView];
	[window makeKeyAndOrderFront:nil];
	[window center];
	[aView setNeedsDisplay:YES];

	[NSApp run];
}

int main (int argc, char const* argv[])
{
  	@autoreleasepool {
		OakSetupApplicationWithView([[MyView alloc] initWithFrame:NSZeroRect], @"Constraint Based Layout Issue");
	}
	return 0;
}
