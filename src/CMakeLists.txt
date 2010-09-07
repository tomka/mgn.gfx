include_directories(
    ${CMAKE_BINARY_DIR}
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/src
)

# Create a library called "mgn.gfx" which includes the source files in this
# directoty. Any number of sources could be listed here.
ADD_LIBRARY (mgn.gfx
             mgn/gfx/utils/ObjectReader.d
             mgn/gfx/utils/ObjectStatisticsReader.d)
