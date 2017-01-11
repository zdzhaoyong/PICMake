include(PICMake)
pi_add_target(AppDemo BIN . DEPENDENCY StaticLibDemo SharedLibDemo)
