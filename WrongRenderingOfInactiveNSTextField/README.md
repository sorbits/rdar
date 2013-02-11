# Summary

When an `NSTextField` with `NSBackgroundStyleRaised` redraws itself in an inactive textured window, it only draws as dimmed if none of its parent views are opaque.

# Steps to Reproduce

Compile and run [`main.mm`](main.mm):

    clang++ -fobjc-arc -framework Cocoa -o /tmp/TestApp main.mm
    /tmp/TestApp

The program opens a window with two gradient views each containing an `NSTextField`. Their setup is identical except the right one is returning `YES` from `isOpaque`.

![Active](images/active.png)

Click outside the window to deactivate it.

# Expected Result

Both labels “fade” together with the window frame.

# Actual Result

Only the left label will fade.

![Inactive](images/inactive.png)

# Notes

I am using the text field in a status bar with a custom gradient background. The other controls in this status bar (`NSPopUpButton`) do render as “faded” when the window is inactive, so if the `NSTextField` behavior is correct, then other controls are likely incorrect.

While my status bar can lie and return `NO` from `isOpaque`, it’s actually one of the parent views that returns `YES` from `isOpaque` due to what I think is a bug related to window dragging and `NSScrollView`, I haven’t filed a radar for this yet though. Will update this issue when I do.
