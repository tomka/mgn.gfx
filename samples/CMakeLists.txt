# Make sure the compiler can find include files from our mgn.gfx library.
INCLUDE_DIRECTORIES (
    ${CMAKE_BINARY_DIR}
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/src
)

# Make sure the linker can find the mgn.gfx library once it is built.
LINK_DIRECTORIES (
    ${HELLO_BINARY_DIR}/mgn.gfx
)

# Add executable called "simpleObjStat" that is built from the source files
# "simpleObjStat.d" The extensions are automatically found.
ADD_EXECUTABLE (simpleObjStat
    simpleObjStat.d
)

# Link the executable to the Hello library.
TARGET_LINK_LIBRARIES (simpleObjStat
    mgn.gfx
)
