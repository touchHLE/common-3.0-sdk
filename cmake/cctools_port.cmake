set(CCTOOLS_SOURCE_DIR "${SOURCES}/cctools-port")
set(CCTOOLS_BUILD_DIR "${CMAKE_BINARY_DIR}/cctools-build")
set(CCTOOLS_BUILD_PREFIX "${CMAKE_BINARY_DIR}/cctools")
set(CCTOOLS_PATCH_FILE "${CMAKE_CURRENT_SOURCE_DIR}/patches/cctools.patch")
set(CCTOOLS_PATCH_STAMP "${CMAKE_BINARY_DIR}/cctools_patch.stamp")

add_custom_command(
    OUTPUT ${CCTOOLS_PATCH_STAMP}
    COMMAND bash -c "if patch -p1 --dry-run -i \"${CCTOOLS_PATCH_FILE}\" > /dev/null 2>&1; then \
                        patch -p1 -i \"${CCTOOLS_PATCH_FILE}\"; \
                    else \
                        echo \"Patch already applied or cannot be applied cleanly\"; \
                    fi"
    COMMAND ${CMAKE_COMMAND} -E touch "${CCTOOLS_PATCH_STAMP}"
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/sources/cctools-port
    COMMENT "Patching cctools-port"
    DEPENDS ${CCTOOLS_PATCH_FILE}
    VERBATIM
)

add_custom_target(build_cctools
    DEPENDS ${CCTOOLS_PATCH_STAMP}
    COMMAND ./autogen.sh
    COMMAND ./configure 
        --prefix=${CCTOOLS_BUILD_PREFIX}
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
    WORKING_DIRECTORY ${CCTOOLS_BUILD_PREFIX}/bin
    COMMENT "Creating symlinks without prefix"
)

install(
    DIRECTORY ${CCTOOLS_BUILD_PREFIX}/
    DESTINATION ${SDK_PATH}/usr
    COMPONENT cctools
)