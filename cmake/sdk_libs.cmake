install(
    DIRECTORY ${SOURCES}/oss-libs/
    DESTINATION ${SDK_PATH}/usr/lib
    COMPONENT sdk_libs
    FILES_MATCHING PATTERN "*.dylib"
)

