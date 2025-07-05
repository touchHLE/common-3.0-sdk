install(
    DIRECTORY
        "${CMAKE_CURRENT_SOURCE_DIR}/sources/cmake-toolchain/Platform"
        "${CMAKE_CURRENT_SOURCE_DIR}/sources/cmake-toolchain/Toolchain"
    DESTINATION "${SDK_PATH}/cmake"
    COMPONENT cmake_toolchain
)
