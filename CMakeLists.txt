cmake_minimum_required(VERSION 3.15)

set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)
set(CMAKE_GENERATOR "Ninja")

project(iPhoneOS3.0SDK)

set(ALL_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/sources")
set(CSU_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}/sources/csu")
set(HEADERS_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}/sources/sdk-headers")
set(SDK_INCLUDE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/iPhoneOS3.0-custom.sdk/usr/include")
set(SDK_PATH "${CMAKE_CURRENT_SOURCE_DIR}/iPhoneOS3.0-custom.sdk")

include(${CMAKE_CURRENT_LIST_DIR}/cmake/sdk_headers.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/cctools_port.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/csu.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/sdk_libs.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/libc_stub.cmake)

add_custom_target(build_sdk ALL
    DEPENDS 
        setup_headers
        build_cctools
        csu
        libsystem 
)

install(FILES 
    "${CMAKE_CURRENT_SOURCE_DIR}/licenses/MPL-2.0"
    "${CMAKE_CURRENT_SOURCE_DIR}/licenses/APSL"
    "${CMAKE_CURRENT_SOURCE_DIR}/licenses/GPL"
    DESTINATION "${SDK_PATH}/licenses"
    COMPONENT licenses
)

install(FILES 
    "${CMAKE_CURRENT_SOURCE_DIR}/README.md"
    DESTINATION "${SDK_PATH}/"
    COMPONENT licenses
)