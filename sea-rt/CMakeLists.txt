add_library(sea-rt
  seahorn.cpp)

add_library(sea-mem-rt
  seahorn_mem.cpp)


install (TARGETS sea-rt
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib)
install (TARGETS sea-mem-rt
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib)


option(SEAHORN_BUILD_32_BIT_RT "Build 32bit sea-rt libraries" OFF)
if(SEAHORN_BUILD_32_BIT_RT) 
  add_library(sea-rt-32 seahorn.cpp)
  set_target_properties(sea-rt-32 PROPERTIES
    COMPILE_FLAGS "-m32" LINK_FLAGS "-m32")
  add_library(sea-mem-rt-32 seahorn_mem.cpp)
  set_target_properties(sea-mem-rt-32 PROPERTIES
    COMPILE_FLAGS "-m32" LINK_FLAGS "-m32")

  install (TARGETS sea-rt-32
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib)
  install (TARGETS sea-mem-rt-32
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib)
endif()

add_library(libUAF-32 libUAF.c)
target_compile_options(libUAF-32 BEFORE PRIVATE -m32 -emit-llvm)
add_library(libUAF-64 libUAF.c)
target_compile_options(libUAF-64 BEFORE PRIVATE -m64 -emit-llvm)
install(FILES $<TARGET_OBJECTS:libUAF-32> 
  DESTINATION lib 
  RENAME libUAF-32.bc
)
install(FILES $<TARGET_OBJECTS:libUAF-64> 
  DESTINATION lib 
  RENAME libUAF-64.bc
)

add_library(mallocRedir-32 mallocRedir.c)
target_compile_options(mallocRedir-32 BEFORE PRIVATE -m32 -emit-llvm)
add_library(mallocRedir-64 mallocRedir.c)
target_compile_options(mallocRedir-64 BEFORE PRIVATE -m64 -emit-llvm)
install(FILES $<TARGET_OBJECTS:mallocRedir-32> 
  DESTINATION lib 
  RENAME mallocRedir-32.bc
)
install(FILES $<TARGET_OBJECTS:mallocRedir-64> 
  DESTINATION lib 
  RENAME mallocRedir-64.bc
)

