cmake_minimum_required(VERSION 3.10)
project(counter_ffi C)

add_library(counter_ffi SHARED counter_ffi.c)
set_target_properties(counter_ffi PROPERTIES OUTPUT_NAME "counter_ffi")

