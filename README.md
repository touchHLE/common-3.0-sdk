# Custom SDK for iPhoneOS3.0 using only OSS sources

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

MMAN-WIN32 (Windows builds only)
- Licensed under MIT License
- Full license text in `licenses/MIT.mman`
- Provides POSIX mmap functionality on Windows

## Important disclaimer

This project is not affiliated with or endorsed by Apple Inc in any way. iPhone, iOS, iPod, iPod touch and iPad are trademarks of Apple Inc in the United States and other countries.