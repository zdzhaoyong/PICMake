include(PICMake)
pi_add_target(AppDemo BIN main.cpp DEPENDENCY StaticLibDemo SharedLibDemo)
