# Custom iPhoneOS3.0.sdk using only OSS sources

## Build SDK

`cmake -S . -B build`

`cmake --build build`

## Create SDK
`cmake --install build`

## Licensing 

This SDK contains components under multiple licenses:

CMake Build System and Custom Components
- Licensed under Mozilla Public License 2.0
- Full license text in `licenses/MPL-2.0`

Apple OSS Headers and Components
- Licensed under Apple Public Source License
- Full license text in `licenses/APSL`

GNU libgcc Library
- Licensed under GNU GPLv2 or later
- Full license text in `licenses/GPL`