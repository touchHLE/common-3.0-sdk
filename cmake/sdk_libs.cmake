file(MAKE_DIRECTORY ${SDK_PATH}/usr/lib)

install(
    DIRECTORY ${ALL_SOURCES}/oss-libs/
    DESTINATION ${SDK_PATH}/usr/lib
    COMPONENT sdk_libs
    FILES_MATCHING PATTERN "*.dylib"
)

