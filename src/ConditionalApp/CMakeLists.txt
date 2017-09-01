include(PICMake)
pi_add_target(ConditionalApp BIN . MODULES Qt PIL QGLViewer System REQUIRED OpenCV)

