set(LIBC_STUB_SOURCE_DIR "${SOURCES}/libc-stub")

set(RC_ARCHS "armv6;armv7")

set(CMAKE_C_COMPILER clang)
set(BASE_C_FLAGS 
    --target=arm-apple-ios
    -miphoneos-version-min=2.0
    -B${CCTOOLS_BUILD_PREFIX}/bin
    -I${CMAKE_BINARY_DIR}/include
)

# Function to add architecture flags target var
function(get_arch_flags out_var)
    set(arch_flags "")
    foreach(arch ${RC_ARCHS})
        list(APPEND arch_flags "-arch" ${arch})
    endforeach()
    set(${out_var} ${arch_flags} PARENT_SCOPE)
endfunction()

get_arch_flags(ARCH_FLAGS)

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