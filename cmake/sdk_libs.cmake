install(
    DIRECTORY ${SOURCES}/oss-libs/
    DESTINATION usr/lib
    COMPONENT sdk_libs
    FILES_MATCHING
    PATTERN "*.dylib"
)
