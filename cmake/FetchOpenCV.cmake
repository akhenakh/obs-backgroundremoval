include(FetchContent)

set(CUSTOM_OPENCV_URL
    ""
    CACHE STRING "URL of a downloaded OpenCV static library tarball")

set(CUSTOM_OPENCV_HASH
    ""
    CACHE STRING "Hash of a downloaded OpenCV static library tarball")

if(CUSTOM_OPENCV_URL STREQUAL "")
  set(USE_PREDEFINED_OPENCV ON)
else()
  if(CUSTOM_OPENCV_HASH STREQUAL "")
    message(FATAL_ERROR "Both of CUSTOM_OPENCV_URL and CUSTOM_OPENCV_HASH must be present!")
  else()
    set(USE_PREDEFINED_OPENCV OFF)
  endif()
endif()

if(USE_PREDEFINED_OPENCV)
  set(OpenCV_VERSION "4.8.0-2")
  set(OpenCV_BASEURL "https://github.com/umireon/obs-backgroundremoval-dep-opencv/releases/download/${OpenCV_VERSION}")

  if(${CMAKE_BUILD_TYPE} STREQUAL Release OR ${CMAKE_BUILD_TYPE} STREQUAL RelWithDebInfo)
    set(OpenCV_BUILD_TYPE Release)
  else()
    set(OpenCV_BUILD_TYPE Debug)
  endif()

  if(APPLE)
    if(OpenCV_BUILD_TYPE STREQUAL Release)
      set(OpenCV_URL "${OpenCV_BASEURL}/opencv-macos-Release.tar.gz")
      set(OpenCV_HASH MD5=f4fb2dd77e7d2e266fb5b0985b4a338a)
    else()
      set(OpenCV_URL "${OpenCV_BASEURL}/opencv-macos-Debug.tar.gz")
      set(OpenCV_HASH MD5=cbd7fa6f49903ba0aa46a18a270d3159)
    endif()
  elseif(MSVC)
    if(OpenCV_BUILD_TYPE STREQUAL Release)
      set(OpenCV_URL "${OpenCV_BASEURL}/opencv-windows-Release.zip")
      set(OpenCV_HASH MD5=9e8caf53878f2c816e97098f63792b2c)
    else()
      set(OpenCV_URL "${OpenCV_BASEURL}/opencv-windows-Debug.zip")
      set(OpenCV_HASH MD5=b814a818c76c5e34bf353c012d7c03cc)
    endif()
  else()
    if(OpenCV_BUILD_TYPE STREQUAL Release)
      set(OpenCV_URL "${OpenCV_BASEURL}/opencv-linux-Release.tar.gz")
      set(OpenCV_HASH MD5=203f9c6214b00a3383f9764afcac9ee9)
    else()
      set(OpenCV_URL "${OpenCV_BASEURL}/opencv-linux-Debug.tar.gz")
      set(OpenCV_HASH MD5=e845d07af6cb6e3b9409b935cb12d382)
    endif()
  endif()
else()
  set(OpenCV_URL "${CUSTOM_OPENCV_URL}")
  set(OpenCV_HASH "${CUSTOM_OPENCV_HASH}")
endif()

FetchContent_Declare(
  opencv
  URL ${OpenCV_URL}
  URL_HASH ${OpenCV_HASH})
FetchContent_MakeAvailable(opencv)

add_library(OpenCV INTERFACE)
if(MSVC)
  target_link_libraries(
    OpenCV
    INTERFACE ${opencv_SOURCE_DIR}/x64/vc17/staticlib/opencv_imgproc480.lib
              ${opencv_SOURCE_DIR}/x64/vc17/staticlib/opencv_core480.lib
              ${opencv_SOURCE_DIR}/x64/vc17/staticlib/opencv_photo480.lib
              ${opencv_SOURCE_DIR}/x64/vc17/staticlib/zlib.lib)
  target_include_directories(OpenCV SYSTEM INTERFACE ${opencv_SOURCE_DIR}/include)
else()
  target_link_libraries(
    OpenCV INTERFACE ${opencv_SOURCE_DIR}/lib/libopencv_imgproc.a ${opencv_SOURCE_DIR}/lib/libopencv_core.a
      ${opencv_SOURCE_DIR}/lib/libopencv_photo.a
                     ${opencv_SOURCE_DIR}/lib/opencv4/3rdparty/libzlib.a)
  target_include_directories(OpenCV SYSTEM INTERFACE ${opencv_SOURCE_DIR}/include/opencv4)
endif()