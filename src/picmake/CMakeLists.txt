cmake_minimum_required(VERSION 2.8)
project(picmake)

include(PICMake)
set(CMAKE_CXX_STANDARD 11)

pi_add_target(picmake BIN src REQUIRED System)

pi_report_target()

pi_install(TARGETS picmake)
