cmake_minimum_required(VERSION 3.10)

project(iPhoneOS3.0SDK)

set(SDK_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}/sources/iPhoneOS3.0.sdk/usr/include")
set(XNU_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}/sources/xnu")
set(SDK_DEST "${CMAKE_CURRENT_SOURCE_DIR}/iPhoneOS3.0-custom.sdk/usr/include")

add_custom_target(copy_sdk_headers
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    "${SDK_SOURCE}"
    "${SDK_DEST}"

    COMMAND ${CMAKE_COMMAND} -E make_directory
    "${SDK_DEST}/arm"
    "${SDK_DEST}/mach"
    "${SDK_DEST}/mach/arm"
    "${SDK_DEST}/mach/machine"
    "${SDK_DEST}/libkern/arm"

    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${XNU_SOURCE}/bsd/arm/*.h"
    "${SDK_DEST}/arm"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${XNU_SOURCE}/osfmk/arm/arch.h"
    "${SDK_DEST}/arm"

    COMMAND ${CMAKE_COMMAND} -E rename
    "${SDK_DEST}/arm/_mcontext.h"
    "${SDK_DEST}/arm/_structs.h"

    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${XNU_SOURCE}/libkern/libkern/arm/OSByteOrder.h"
    "${SDK_DEST}/libkern/arm/OSByteOrder.h"

    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${XNU_SOURCE}/osfmk/mach/*.h"
    "${SDK_DEST}/mach"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${XNU_SOURCE}/osfmk/mach/arm/*.h"
    "${SDK_DEST}/mach/arm"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${XNU_SOURCE}/osfmk/mach/machine/*.h"
    "${SDK_DEST}/mach/machine"
    # Need to overwrite with old message.h
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${SDK_SOURCE}/mach/message.h"
    "${SDK_DEST}/mach"

    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${XNU_SOURCE}/EXTERNAL_HEADERS/stdint.h"
    "${SDK_DEST}/stdint.h"

    COMMENT "Copying SDK headers and overlaying OSS headers"
)

add_custom_command(
    TARGET copy_sdk_headers
    POST_BUILD
    COMMAND patch -p0 -i ${CMAKE_CURRENT_SOURCE_DIR}/patches/stdint.patch ${SDK_DEST}/stdint.h
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Applying patches to stdint.h"
)