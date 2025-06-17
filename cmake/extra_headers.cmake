install(
    DIRECTORY ${SOURCES}/extra-headers/
    DESTINATION ${SDK_PATH}/usr/include
    COMPONENT extra_headers
    FILES_MATCHING
    PATTERN "*.h"
)
