# Custom SDK for iPhoneOS3.0 using only OSS sources

## Build SDK

`cmake -S . -B build`

`cmake --build build`

## Create SDK
`cmake --install build`

## Licensing 

This SDK contains components under multiple licenses:

### Build System and Custom Components
- This includes CMake Scripts and Header Extraction Scripts
- License: MPL 2.0 (see `licenses/MPL-2.0`)

### Apple Open Source Components
- This includes cctools-port, csu and headers from several apple open source libraries
- License: APSL (see `licenses/APSL`)

### GNU libgcc Library
- Licensed under GNU GPLv2 or later
- License: GPLv2 (see `licenses/GPLv2`)

### Build Dependencies
The following libraries are used for building but are not included in the SDK:

**pygit2**
- License: GPLv2 with linking exception (see [pypi](https://pypi.org/project/pygit2/))

**PyYAML**
- License: MIT (see [pypi](https://pypi.org/project/PyYAML/))

### Windows-Specific Components
The following additional components are only included in Windows builds:

**mman-win32**
- License: MIT (see `licenses/COPYING.mman`)

**dlfcn-win32**
- License: MIT (see `licenses/COPYING.dlfcn`)

**libstdc++**
- License: GPL-3.0-or-later with the GCC-exception-3.1 (see `licenses/COPYING.libc++`)

**libgcc**
- License: GPL-3.0-or-later with the GCC-exception-3.1 (see `licenses/COPYING.libgcc`)

**winpthreads**
- License: MIT and BSD Style License (see `licenses/COPYING.winpthreads`)

## Important disclaimer

This project is not affiliated with or endorsed by Apple Inc in any way. iPhone, iOS, iPod, iPod touch and iPad are trademarks of Apple Inc in the United States and other countries.