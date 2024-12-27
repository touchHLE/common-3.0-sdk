find_package(Python3 REQUIRED)

file(MAKE_DIRECTORY ${SDK_PATH}/usr)

set(VENV_DIR "${CMAKE_BINARY_DIR}/.venv")

add_custom_command(
    OUTPUT ${VENV_DIR}/pyvenv.cfg
    COMMAND ${Python3_EXECUTABLE} -m venv ${VENV_DIR}
    COMMENT "Creating virtual environment"
)

add_custom_target(venv DEPENDS ${VENV_DIR}/pyvenv.cfg)

message(STATUS "HEADERS_SOURCE before include: ${HEADERS_SOURCE}")

add_custom_command(
    OUTPUT ${VENV_DIR}/requirements_installed
    COMMAND ${VENV_DIR}/bin/pip install -r ${HEADERS_SOURCE}/requirements.txt
    COMMAND ${CMAKE_COMMAND} -E touch ${VENV_DIR}/requirements_installed
    DEPENDS venv ${HEADERS_SOURCE}/requirements.txt
    COMMENT "Installing Python requirements"
)

add_custom_target(install_requirements DEPENDS ${VENV_DIR}/requirements_installed)

add_custom_target(setup_headers ALL
    COMMAND ${VENV_DIR}/bin/python ${HEADERS_SOURCE}/extract_ios_headers.py 
        --config ${HEADERS_SOURCE}/header_sources.yaml --patches ${HEADERS_SOURCE}/patches
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    DEPENDS install_requirements
    COMMENT "Running Python script"
)

install(
    DIRECTORY ${CMAKE_BINARY_DIR}/include
    DESTINATION ${SDK_PATH}/usr
    COMPONENT headesr
)