get_filename_component(SDK_PATH "${CMAKE_CURRENT_LIST_DIR}/../.." ABSOLUTE)
set(SDK_PATH "${SDK_PATH}" CACHE PATH "SDK installation path" FORCE)
list(APPEND CMAKE_MODULE_PATH "${SDK_PATH}/cmake")

set(CMAKE_SYSTEM_NAME common-3.0)
set(CMAKE_SYSTEM_VERSION 3.0)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_SYSROOT ${SDK_PATH})

if(DEFINED ENV{CC})
    set(CMAKE_C_COMPILER $ENV{CC})
else()
    set(CMAKE_C_COMPILER clang)
endif()

if(DEFINED ENV{CXX})
    set(CMAKE_CXX_COMPILER $ENV{CXX})
else()
    set(CMAKE_CXX_COMPILER clang++)
endif()

set(CMAKE_C_COMPILER_TARGET arm-apple-ios3.0)

if(NOT CMAKE_ARCHITECTURES)
    set(CMAKE_ARCHITECTURES "armv6;armv7")
endif()

string(REPLACE ";" " -arch " ARCH_FLAGS "-arch ${CMAKE_ARCHITECTURES}")

set(CMAKE_C_FLAGS_INIT
    "-B${SDK_PATH}/usr/bin ${ARCH_FLAGS} -Wno-incompatible-sysroot -mlinker-version=253 -mfpu=vfpv2"
)

set(CMAKE_FIND_ROOT_PATH ${SDK_PATH})
