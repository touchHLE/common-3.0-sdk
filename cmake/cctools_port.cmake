add_custom_target(patch_cctools
    COMMAND patch -p1 -N -i ${CMAKE_CURRENT_SOURCE_DIR}/patches/cctools.patch || true
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/sources/cctools-port
    COMMENT "Patching cctools-port"
)

add_custom_target(build_cctools
    DEPENDS patch_cctools
    COMMAND ./autogen.sh

    COMMAND ./configure 
        --prefix=${SDK_PATH}/usr
        --target=arm-apple-darwin10
    
    COMMAND make
    COMMAND make install

    
    
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/sources/cctools-port/cctools
    COMMENT "Building cctools-port"
)

add_custom_command(
    TARGET build_cctools
    POST_BUILD
    COMMAND bash ${CMAKE_CURRENT_SOURCE_DIR}/cmake/scripts/cctool_symlinks.sh

    WORKING_DIRECTORY ${SDK_PATH}/usr/bin
    COMMENT "Creating symlinks without prefix"
)