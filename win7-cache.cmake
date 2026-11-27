set(CMAKE_C_FLAGS "/D_WIN32_WINNT=0x0601 /DWINVER=0x0601" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "/D_WIN32_WINNT=0x0601 /DWINVER=0x0601" CACHE STRING "" FORCE)

# ===== CPU 指令集基线：E5640 (Westmere, 2010) 只支持到 SSE4.2，无 AVX =====
# v1.0.0 源码 (ggml/CMakeLists.txt) 的关键陷阱：
#   if (GGML_NATIVE OR NOT GGML_NATIVE_DEFAULT)
#       set(INS_ENB OFF)
#   else()
#       set(INS_ENB ON)     # <- workflow 设了 GGML_NATIVE=OFF，落到这一支
#   endif()
#   option(GGML_AVX2 "..." ${INS_ENB})   # -> AVX2/AVX/BMI2/SSE42 全部默认 ON
# 即：-DGGML_NATIVE=OFF 不会降级指令集，反而让所有 SIMD 默认打开。
# MSVC 下 GGML_AVX2=ON -> /arch:AVX2 编译整个 ggml-cpu；E5640 执行到 AVX2
# 指令即 0xc000001d (STATUS_ILLEGAL_INSTRUCTION)，表现为 --version 正常、
# 加载模型进入矩阵乘内核时崩溃。故必须显式逐个关闭，只留 SSE4.2。
# 这些值用 CACHE FORCE 在此一次性给全（先于 option() 定义，option 不会覆盖）。
set(GGML_NATIVE      OFF CACHE BOOL "" FORCE)
set(GGML_SSE42       ON  CACHE BOOL "" FORCE)
set(GGML_AVX         OFF CACHE BOOL "" FORCE)
set(GGML_AVX2        OFF CACHE BOOL "" FORCE)
set(GGML_AVX_VNNI    OFF CACHE BOOL "" FORCE)
set(GGML_AVX512      OFF CACHE BOOL "" FORCE)
set(GGML_AVX512_VBMI OFF CACHE BOOL "" FORCE)
set(GGML_AVX512_VNNI OFF CACHE BOOL "" FORCE)
set(GGML_AVX512_BF16 OFF CACHE BOOL "" FORCE)
set(GGML_FMA         OFF CACHE BOOL "" FORCE)
set(GGML_F16C        OFF CACHE BOOL "" FORCE)
set(GGML_BMI2        OFF CACHE BOOL "" FORCE)
set(GGML_AMX_TILE    OFF CACHE BOOL "" FORCE)
set(GGML_AMX_INT8    OFF CACHE BOOL "" FORCE)
set(GGML_AMX_BF16    OFF CACHE BOOL "" FORCE)
# CUDA 的宏定义【必须】用 nvcc 的 -D 语法，不能用 cl 的 /D！
#   nvcc 不认 /D，会把 /D_WIN32_WINNT=0x0601 当成输入文件名 -> 报
#   "A single input file is required for a non-link phase when an output file is specified"。
#   -D 是 nvcc 原生(--define-macro)，会同时定义到 host 与 device；host 侧由 cl 编译即可读到该宏。
# 此值必须在此一次性给全：命令行 -DCMAKE_CUDA_FLAGS 会【覆盖】本文件 CACHE FORCE 值，
# 所以 workflow 不能再单独 -DCMAKE_CUDA_FLAGS（否则宏丢失或顺序错乱）。
# -allow-unsupported-compiler：让 nvcc 11.4 接受 VS2019(cl 19.2x) host 编译器。
set(CMAKE_CUDA_FLAGS "-D_WIN32_WINNT=0x0601 -DWINVER=0x0601 -allow-unsupported-compiler" CACHE STRING "" FORCE)
