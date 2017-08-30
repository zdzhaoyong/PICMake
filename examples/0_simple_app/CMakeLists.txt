cmake_minimum_required(VERSION 2.8) 
include(PICMake)
pi_add_target(simple_app BIN main.cpp REQUIRED Qt)
pi_report_target()
