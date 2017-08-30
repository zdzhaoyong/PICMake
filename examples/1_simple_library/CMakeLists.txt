cmake_minimum_required(VERSION 2.8)
include(PICMake)
pi_add_target(simple_library SHARED showImage.cpp REQUIRED OpenCV)
pi_report_targets()
