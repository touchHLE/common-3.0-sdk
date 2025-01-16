cmake_minimum_required(VERSION 3.15)

set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)
set(CMAKE_GENERATOR "Ninja")

project(iPhoneOS3.0SDK)

set(SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/sources")
set(CSU_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}/sources/csu")
set(HEADERS_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}/sources/sdk-headers")
set(SDK_PATH "${CMAKE_CURRENT_SOURCE_DIR}/common-3.0.sdk")

include(${CMAKE_CURRENT_LIST_DIR}/cmake/sdk_headers.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/cctools_port.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/csu.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/sdk_libs.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/libc_stub.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/licenses.cmake)

add_custom_target(build_sdk ALL
    DEPENDS 
        setup_headers
        build_cctools
        csu
        libsystem 
)