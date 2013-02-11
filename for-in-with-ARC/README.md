# Summary

Using a for-in loop with a ternary operator (`?:`) will under certain circumstances generate incorrect code.

# Steps to Reproduce

Compile and run [`main.m`](main.m):

	CC=$(xcode-select -print-path)/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang
	"$CC" --version
	"$CC" -fobjc-arc -Os -framework Cocoa -o /tmp/main.exe main.m
	/tmp/main.exe

# Expected Result

	Apple LLVM version 4.2 (clang-425.0.24) (based on LLVM 3.2svn)
	Target: x86_64-apple-darwin12.2.0
	Thread model: posix
	2013-01-30 10:52:48.617 main.exe[3085:707] /tmp
	2013-01-30 10:52:48.618 main.exe[3085:707] /etc

# Actual Result

	Apple LLVM version 4.2 (clang-425.0.24) (based on LLVM 3.2svn)
	Target: x86_64-apple-darwin12.2.0
	Thread model: posix
	Segmentation fault: 11

# Notes

This crash started after upgrading to Xcode 4.6 (clang-425.0.24).

A workaround is to use `@[ ]` instead of `nil` in the for-in loop.
