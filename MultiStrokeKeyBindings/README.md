# Summary

Multi-stroke key bindings fail to work for a lot of applications.

# Steps to Reproduce

1. Create `~/Library/KeyBindings/DefaultKeyBinding.dict` containing:

		{
			"^m" = {
				"m" = ("insertText:", "✓");
				"x" = ("insertText:", "×");
			};
		}

2. Open Mail and press ⌘N to compose a new message.

3. Use <kbd>⌃M</kbd> + <kbd>M</kbd> or <kbd>X</kbd> to insert `✓` or `×` respectively, either in subject text field or in the email body.

# Expected Result

The desired characters are inserted (`✓` or `×`).

# Actual Result

The error beep is heard.

# Notes

With 10.6 I think multi-stroke key bindings worked flawlessly in all applications except for `<textarea>` in Safari forms.

10.7 started to see issues, particularly in Mail, where inserting characters via multi-stroke key bindings often added an extra newline.

With 10.8 most applications now fail to properly support multi-stroke key bindings.

_Tracking ID: <rdar://13252662>_
