_This was sent to the objc-language list at <http://lists.apple.com/>_

# Summary

If I build & run [`main.cc`](main.cc) using `-fobjc-link-runtime` and set deployment target to 10.7 then my `std::shared_ptr` instance is never released, i.e. the block is being leaked.

# Steps to Reproduce

    xcrun clang++ -mmacosx-version-min=10.7 -fobjc-link-runtime -std=c++11 -stdlib=libc++ -o a.out main.cc
    ./a.out

# Expected Result

    0x7faa53406aa0: create
    0x7faa53406aa0: invoke
    0x7faa53406aa0: dispose

# Actual Result

    0x7faa53406aa0: create
    0x7faa53406aa0: invoke

# System Info

    Mac OS X 10.8.2 Build 12C60
    Apple LLVM version 4.2 (clang-425.0.24) (based on LLVM 3.2svn).

# Notes

The issue can be avoided in any of these ways:

 1. Set `-mmacosx-version-min` to `10.8` instead of `10.7`.
 2. Leave out `-fobjc-link-runtime`.
 3. Add `-x objective-c++` or rename `main.cc` to `main.mm`.

I confess to not fully understanding the effect of `-fobjc-link-runtime` so I might violate some contract by providing this option for a pure C++ program — it is my understanding that the option is required to provide the proper ARC run-time support when deploying to 10.7. The reason it was set for a pure C++ program (which doesn’t use ARC) is because of an automated build system that doesn’t discriminate. I will be grateful to anyone who can point me to documentation regarding `-fobjc-link-runtime`.

Likewise I also miss documentation on `-fobjc-arc-cxxlib`. Can anyone tell me what the option does, when it is important or makes a difference?
