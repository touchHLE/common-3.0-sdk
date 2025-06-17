install(
    FILES
        "${CMAKE_CURRENT_SOURCE_DIR}/licenses/MPL-2.0"
        "${CMAKE_CURRENT_SOURCE_DIR}/licenses/APSL"
        "${CMAKE_CURRENT_SOURCE_DIR}/licenses/GPL"
    DESTINATION "${SDK_PATH}/licenses"
    COMPONENT licenses
)

install(
    FILES "${CMAKE_CURRENT_SOURCE_DIR}/README.md"
    DESTINATION "${SDK_PATH}/"
    COMPONENT licenses
)

if(WIN32)
    install(
        FILES "${CMAKE_CURRENT_SOURCE_DIR}/licenses/MIT.mman"
        DESTINATION "${SDK_PATH}/licenses"
        COMPONENT licenses
    )
endif()
