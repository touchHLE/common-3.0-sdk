install(
    DIRECTORY ${SOURCES}/extra-headers/
    DESTINATION usr/include
    COMPONENT extra_headers
    FILES_MATCHING
    PATTERN "*.h"
)
