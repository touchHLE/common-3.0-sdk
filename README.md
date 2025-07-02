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
- Full license text in `LICENSES/MPL-2.0`

Apple OSS Headers and Components
- Licensed under Apple Public Source License
- Full license text in `LICENSES/APSL`

GNU libgcc Library
- Licensed under GNU GPLv2 or later
- Full license text in `LICENSES/GPLv2`

### Windows Builds Only

MMAN-WIN32
- Licensed under MIT License
- Full license text in `LICENSES/MIT.mman`

dlfcn
- Licensed under MIT License
- Full license text in `LICENSES/COPYING.dlfcn`

libstdc++
- Licensed under GPL-3.0-or-later with the GCC-exception-3.1
- Full license text in `LICENSES/COPYING.libc++`

libgcc
- Licensed under GPL-3.0-or-later with the GCC-exception-3.1
- Full license text in `LICENSES/COPYING.libgcc`

winpthreads
- Licensed under MIT License and BSD Style License
- Full license text in `LICENSES/COPYING.winpthreads`

## Important disclaimer

This project is not affiliated with or endorsed by Apple Inc in any way. iPhone, iOS, iPod, iPod touch and iPad are trademarks of Apple Inc in the United States and other countries.