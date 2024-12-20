cmake_minimum_required(VERSION 3.10)

project(iPhoneOS3.0SDK)

set(ALL_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/sources")
set(SDK_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}/sources/iPhoneOS3.0.sdk/usr/include")
set(XNU_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}/sources/xnu")
set(CSU_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}/sources/csu")
set(SDK_DEST "${CMAKE_CURRENT_SOURCE_DIR}/iPhoneOS3.0-custom.sdk/usr/include")
set(SDK_PATH "${CMAKE_CURRENT_SOURCE_DIR}/iPhoneOS3.0-custom.sdk")

include(${CMAKE_CURRENT_LIST_DIR}/cmake/sdk_headers.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/cctools_port.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/csu.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/sdk_libs.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/libc_stub.cmake)

add_custom_target(all ALL
    DEPENDS
        copy_sdk_headers
        build_cctools
        copy_sdk_libs
        csu
        libsystem
)