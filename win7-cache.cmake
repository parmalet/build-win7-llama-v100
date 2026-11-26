set(CMAKE_C_FLAGS "/D_WIN32_WINNT=0x0601 /DWINVER=0x0601" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "/D_WIN32_WINNT=0x0601 /DWINVER=0x0601" CACHE STRING "" FORCE)
# CUDA：宏定义必须和 nvcc 选项在此一次性给全。
# 原因：CMake 里命令行 -DCMAKE_CUDA_FLAGS 会【覆盖】本文件的 CACHE FORCE 值，
# 所以 workflow 不能再单独 -DCMAKE_CUDA_FLAGS，否则 _WIN32_WINNT 会丢失。
# -allow-unsupported-compiler：让 nvcc 11.4 接受 VS2019(cl 19.2x) host 编译器。
set(CMAKE_CUDA_FLAGS "/D_WIN32_WINNT=0x0601 /DWINVER=0x0601 -allow-unsupported-compiler" CACHE STRING "" FORCE)
