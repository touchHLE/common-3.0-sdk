get_filename_component(SDK_PATH "${CMAKE_CURRENT_LIST_DIR}/../.." ABSOLUTE)
list(APPEND CMAKE_MODULE_PATH "${SDK_PATH}/cmake")

set(CMAKE_SYSTEM_NAME common-3.0)
set(CMAKE_SYSTEM_VERSION 3.0)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_C_COMPILER clang)

set(CMAKE_C_COMPILER_TARGET arm-apple-ios3.0)

if(NOT CMAKE_ARCHITECTURES)
    set(CMAKE_ARCHITECTURES "armv6;armv7")
endif()

string(REPLACE ";" " -arch " ARCH_FLAGS "-arch ${CMAKE_ARCHITECTURES}")

set(CMAKE_C_FLAGS_INIT
    "-isysroot ${SDK_PATH} -B${SDK_PATH}/usr/bin ${ARCH_FLAGS} -Wno-incompatible-sysroot -mlinker-version=253 -mfpu=vfpv2"
)

set(CMAKE_FIND_ROOT_PATH ${SDK_PATH})
