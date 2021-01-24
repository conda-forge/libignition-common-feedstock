#!/bin/sh

mkdir build
cd build

if [ ${target_platform} == "linux-aarch64" ] || [ ${target_platform} == "linux-ppc64le" ]; then
  # Disable tests
  IGN_TEST_CMD=-DBUILD_TESTING:BOOL=OFF
  # Try-run doesn't work on cross-compile
  IGN_TRY_RUN_CACHE=-DFREEIMAGE_RUNS:BOOL=ON
  IGN_TRY_RUN_CACHE_ADVANCED=-DFREEIMAGE_RUNS__TRYRUN_OUTPUT=""
else
  IGN_TEST_CMD=
  IGN_TRY_RUN_CACHE=
  IGN_TRY_RUN_CACHE_ADVANCED=
fi

cmake .. \
      -G "Ninja" \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=$PREFIX -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=True \
      -DCMAKE_CXX_STANDARD=17 \
      ${IGN_TEST_CMD} \
      ${IGN_TRY_RUN_CACHE} \
      ${IGN_TRY_RUN_CACHE_ADVANCED} \
      ${CMAKE_ARGS}

cmake --build . --config Release
cmake --build . --config Release --target install
