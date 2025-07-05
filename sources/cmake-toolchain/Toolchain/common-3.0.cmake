get_filename_component(SDK_PATH "${CMAKE_CURRENT_LIST_DIR}/../.." ABSOLUTE)
list(APPEND CMAKE_MODULE_PATH "${SDK_PATH}/cmake")

set(CMAKE_SYSTEM_NAME common-3.0)
set(CMAKE_SYSTEM_VERSION 3.0)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_C_COMPILER clang)
set(CMAKE_C_COMPILER_TARGET arm-apple-ios3.0)

set(CMAKE_LINKER ${SDK_PATH}/usr/bin/ld)
set(LIPO ${SDK_PATH}/usr/bin/lipo)

set(CMAKE_OSX_SYSROOT ${SDK_PATH}) # Does not seem to work
set(CMAKE_OSX_ARCHITECTURES armv6 armv7)
set(CMAKE_OSX_DEPLOYMENT_TARGET 3.0)
set(CMAKE_C_COMPILER_TARGET arm-apple-ios3.0)

set(CMAKE_C_FLAGS_INIT "-isysroot ${SDK_PATH}")

set(CMAKE_FIND_ROOT_PATH ${SDK_PATH})
