set(CMAKE_C_FLAGS "/D_WIN32_WINNT=0x0601 /DWINVER=0x0601" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "/D_WIN32_WINNT=0x0601 /DWINVER=0x0601" CACHE STRING "" FORCE)
# CUDA 的宏定义【必须】用 nvcc 的 -D 语法，不能用 cl 的 /D！
#   nvcc 不认 /D，会把 /D_WIN32_WINNT=0x0601 当成输入文件名 -> 报
#   "A single input file is required for a non-link phase when an output file is specified"。
#   -D 是 nvcc 原生(--define-macro)，会同时定义到 host 与 device；host 侧由 cl 编译即可读到该宏。
# 此值必须在此一次性给全：命令行 -DCMAKE_CUDA_FLAGS 会【覆盖】本文件 CACHE FORCE 值，
# 所以 workflow 不能再单独 -DCMAKE_CUDA_FLAGS（否则宏丢失或顺序错乱）。
# -allow-unsupported-compiler：让 nvcc 11.4 接受 VS2019(cl 19.2x) host 编译器。
set(CMAKE_CUDA_FLAGS "-D_WIN32_WINNT=0x0601 -DWINVER=0x0601 -allow-unsupported-compiler" CACHE STRING "" FORCE)
