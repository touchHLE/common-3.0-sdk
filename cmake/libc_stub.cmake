set(LIBC_STUB_SOURCE_DIR "${SOURCES}/libc-stub")

set(ARCH_FLAGS -arch armv6 -arch armv7)

set(CMAKE_C_COMPILER clang)
set(BASE_C_FLAGS 
    --target=arm-apple-ios
    -miphoneos-version-min=2.0
    -B${CCTOOLS_BUILD_PREFIX}/bin
    -I${CMAKE_BINARY_DIR}/include
)

add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/libSystem.B.dylib
    COMMAND ${CMAKE_C_COMPILER} -r ${ARCH_FLAGS} ${BASE_C_FLAGS}
            -fno-builtin -nostdlib
            ${LIBC_STUB_SOURCE_DIR}/stub.c
            -Wl,-install_name,/usr/lib/libSystem.B.dylib
            -Wl,-dylib
            -o ${CMAKE_BINARY_DIR}/libSystem.B.dylib
    DEPENDS setup_headers
    COMMENT libSystem.B.dylib
)

add_custom_target(libsystem ALL 
    DEPENDS ${CMAKE_BINARY_DIR}/libSystem.B.dylib
)

install(FILES
    ${CMAKE_BINARY_DIR}/libSystem.B.dylib
    DESTINATION ${SDK_PATH}/usr/lib
)