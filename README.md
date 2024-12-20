# Custom iPhoneOS3.0.sdk using only OSS sources

## Setup build

`mkdir build`

`cd build && cmake ..`

## Make all targets

`make copy_sdk_headers`

`make builc_cctools`

`make copy_sdk_libs`

`make csu`

`make libsystem`

`make install`