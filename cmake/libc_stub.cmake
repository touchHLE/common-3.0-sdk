include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/utils.cmake)

set(LIBC_STUB_SOURCE_DIR "${SOURCES}/libc-stub")

set(CMAKE_C_COMPILER clang)
set(BASE_C_FLAGS
    --target=arm-apple-ios
    -miphoneos-version-min=2.0
    -B${CCTOOLS_BUILD_PREFIX}/bin
    -I${CMAKE_BINARY_DIR}/include
)

build_universal_component(libSystem.B.dylib
    "${BASE_C_FLAGS};-fno-builtin;-nostdlib;-miphoneos-version-min=2.0"
    "-install_name;/usr/lib/libSystem.B.dylib;-dylib;-ios_version_min;3.0"
    "${LIBC_STUB_SOURCE_DIR}/libc_stub.c"
    DEPENDS setup_headers cctools_port
)

add_custom_target(libsystem ALL DEPENDS ${CMAKE_BINARY_DIR}/libSystem.B.dylib)

install(
    FILES ${CMAKE_BINARY_DIR}/libSystem.B.dylib
    DESTINATION usr/lib
)

# Also install as libSystem.dylib.
# Ideally, this would be symlinked but that's flaky on windows.
install(
    FILES ${CMAKE_BINARY_DIR}/libSystem.B.dylib
    DESTINATION usr/lib
    RENAME libSystem.dylib
)
