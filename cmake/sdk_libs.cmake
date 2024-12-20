add_custom_target(copy_sdk_libs
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${CMAKE_CURRENT_SOURCE_DIR}/sources/iPhoneOS3.0.sdk/usr/lib/libgcc_s.1.dylib"
    "${CMAKE_CURRENT_SOURCE_DIR}/iPhoneOS3.0-custom.sdk/usr/lib/libgcc_s.1.dylib"

    COMMENT "Copying OSS dylibs"
)

