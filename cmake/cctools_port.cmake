set(CCTOOLS_SOURCE_DIR "${SOURCES}/cctools-port")
set(CCTOOLS_BUILD_DIR "${CMAKE_BINARY_DIR}/cctools-build")
set(CCTOOLS_BUILD_PREFIX "${CMAKE_BINARY_DIR}/cctools")
set(CCTOOLS_PATCH_FILE "${CMAKE_CURRENT_SOURCE_DIR}/patches/cctools.patch")
set(CCTOOLS_PATCH_STAMP "${CMAKE_BINARY_DIR}/cctools_patch.stamp")

file(MAKE_DIRECTORY ${CCTOOLS_BUILD_PREFIX})
file(MAKE_DIRECTORY ${CCTOOLS_BUILD_DIR})

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

add_custom_command(
    OUTPUT ${CCTOOLS_SOURCE_DIR}/cctools/configure
    COMMAND ./autogen.sh
    WORKING_DIRECTORY ${CCTOOLS_SOURCE_DIR}/cctools
    COMMENT "Running cctools autogen.sh"
    DEPENDS ${CCTOOLS_PATCH_STAMP}
)

add_custom_command(
    OUTPUT ${CCTOOLS_BUILD_DIR}/config.status
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CCTOOLS_BUILD_DIR}
    COMMAND ${CCTOOLS_SOURCE_DIR}/cctools/configure --prefix=${CCTOOLS_BUILD_PREFIX} --target=arm-apple-darwin10
    WORKING_DIRECTORY ${CCTOOLS_BUILD_DIR}
    COMMENT "Configuring cctools build environment"
    DEPENDS ${CCTOOLS_SOURCE_DIR}/cctools/configure
)

add_custom_target(cctools_port
    COMMAND make -j${CMAKE_BUILD_PARALLEL_LEVEL}
    COMMAND make install
    WORKING_DIRECTORY ${CCTOOLS_BUILD_DIR}
    COMMENT "Building cctools-port"
    DEPENDS ${CCTOOLS_BUILD_DIR}/config.status
)

add_custom_command(
    TARGET cctools_port
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