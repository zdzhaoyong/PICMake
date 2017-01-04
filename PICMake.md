# PICMake （版本 1.0）

---

## 1. CMake简介
### 1.1. CMake是神马？
CMake是一个跨平台的安装（编译）工具，可以用简单的语句来描述所有平台的安装(编译过程)。他能够输出各种各样的makefile或者project文件，能测试编译器所支持的C++特性,类似UNIX下的automake。只是 CMake 的组态档取名为 CmakeLists.txt。Cmake 并不直接建构出最终的软件，而是产生标准的建构档（如 Unix 的 Makefile 或 Windows Visual C++ 的 projects/workspaces），然后再依一般的建构方式使用。这使得熟悉某个集成开发环境（IDE）的开发者可以用标准的方式建构他的软件，这种可以使用各平台的原生建构系统的能力是 CMake 和 SCons 等其他类似系统的区别之处。

### 1.2. CMake安装
Linux平台安装：只需要使用一个简单的命令：

        sudo apt-get install cmake

Windows平台安装：可在官网(http://www.cmake.org)上直接下载最新的CMake版本并安装。

### 1.2. 利用CMake编译简单程序
  
### 1.3. 利用CMake编译简单库
  
### 1.4. 利用CMake编译复杂库

## 2. PICMake简介
### 2.1. PICMake是神马？
由于CMake仍然有很多弹性，不够统一的风格可能导致相互之间的支持较差，因此导致用户的工作量增大。
可以认为PICMake其实是规定了一个使用CMake的标准, 当用户按照此标准来使用CMake时，可以大大简化工作流程。
PICMake目前主要针对Linux下的C++工程，目前主要集成了CV领域的常用库支持，我们将持续对其进行改进更新，也欢迎更多开发者提出更多的意见。

### 2.2. PICMake的安装
PICMake的安装和使用过程非常类似，同样都使用cmake，以下是安装步骤：
```
mkdir build
cd build
make
sudo make install
```
实际上make过程编译了一个简单C++程序，make install实际上是在CMake安装目录下创建了一个"PICMake.cmake"文件，并在里面include了真正的PICMake路径。

### 2.1. PICMake中的使用规则
#### 2.1.1. 目录结构
#### 2.1.2. 内建变量

| 变量名        | 变量说明      |
| ------------- |:-------------:|
|MAKE_TYPE|                     编译类型，"bin","static","shared"
|MODULES|                       依赖包
|COMPILEFLAGS|                  编译选项，头文件依赖
|LINKFLAGS|                     链接选项，库依赖
|PACKAGE_FIND_NAME|             需要寻找的包名字|
|PACKAGE_FIND_VERSION|          需要寻找的包版本|
|PACKAGE_FIND_VERSION_MAJOR|    需要寻找的主版本号|
|PACKAGE_FIND_VERSION_MINOR|    需要寻找的次版本号|
|PACKAGE_FIND_COMPONENTS|       需要寻找的组件|
|PACKAGE_FOUND |                判断包PACKAGE是否被成功找到（TRUE,FALSE)|
|PACKAGE_VERSION |              返回包PACKAGE的版本号字符串|
|PACKAGE_INCLUDES|              同PACKAGE_INCLUDE_DIR,返回包的头文件地址|
|PACKAGE_LIBRARIES|             同PACKAGE_LIBRARY,PACKAGE_LIBS，返回包的库依赖|
|PACKAGE_DEFINITIONS|           返回包中需要的|


#### 2.1.3. 内建函数


## 3. PICMake使用介绍
### 3.1. 利用PICMake编译简单程序

### 3.2. 利用PICMake编译简单库

### 3.3. 利用PICMake编译复杂库



## 4. 附录
### 1.5. CMake常用变量
| 变量名        | 变量说明      |
| ------------- |:-------------:|
|PROJECT_NAME |                 返回通过PROJECT指令定义的项目名称|
|PROJECT_SOURCE_DIR|            CMake源码地址，即cmake命令后指定的地址|
|PROJECT_BINARY_DIR|            运行cmake命令的目录,通常是PROJECT_SOURCE_DIR下的build目录|
|CMAKE_MODULE_PATH|             定义自己的cmake模块所在的路径|
|CMAKE_CURRENT_SOURCE_DIR |     当前处理的CMakeLists.txt所在的路径|
|CMAKE_CURRENT_LIST_DIR|        当前文件夹路径|
|CMAKE_CURRENT_LIST_FILE|       输出调用这个变量的CMakeLists.txt的完整路径|
|CMAKE_CURRENT_LIST_LINE|       输出这个变量所在的行|
|CMAKE_RUNTIME_OUTPUT_DIRECTORY|生成可执行文件路径|
|CMAKE_LIBRARY_OUTPUT_DIRECTORY|生成库的文件夹路径|
|CMAKE_BUILD_TYPE|              指定基于make的产生器的构建类型（Release，Debug）|
|CMAKE_C_FLAGS|                 *.C文件编译选项，如 *-std=c99 -O3 -march=native*|
|CMAKE_CXX_FLAGS|               *.CPP文件编译选项，如 *-std=c++11 -O3 -march=native*|
|CMAKE_CURRENT_BINARY_DIR |     target编译目录|
|CMAKE_INCLUDE_PATH |           环境变量,非cmake变量|
|CMAKE_LIBRARY_PATH |           环境变量|
|CMAKE_STATIC_LIBRARY_PREFIX|   静态库前缀, Linux下默认为lib
|CMAKE_STATIC_LIBRARY_SUFFIX|   静态库后缀，Linux下默认为.a
|CMAKE_SHARED_LIBRARY_PREFIX|   动态库前缀，Linux下默认为lib
|CMAKE_SHARED_LIBRARY_SUFFIX|   动态库后缀，Linux下默认为.so
|BUILD_SHARED_LIBS|             如果为ON，则add_library默认创建共享库|
|CMAKE_INSTALL_PREFIX|          配置安装路径，默认为/usr/local|
|CMAKE_ABSOLUTE_DESTINATION_FILES|安装文件列表时使用ABSOLUTE DESTINATION 路径|
|CMAKE_AUTOMOC_RELAXED_MODE |   在严格和宽松的automoc模式间切换|
|CMAKE_BACKWARDS_COMPATIBILITY| 构建工程所需要的CMake版本|
|CMAKE_COLOR_MAKEFILE|          开启时，使用Makefile产生器会产生彩色输出|
|CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS |用来控制IF ELSE语句的书写方式|

### 1.5. CMake常用命令
| 命令名        | 变量说明      |
| ------------- |:-------------:|
|project()|                     设置工程名 `project(PROJECT_NAME)`|
|set()|                         设置变量值`set(VALUE_NAME VALUE)`|
|unset()|                       unset(VAR CACHE) 用于移除变量 VAR|
|include()|                     包含文件|
|cmake_minimum_required()|      设置CMake版本要求`cmake_minimum_required(VERSION 2.8.6)`|
|message()|                     `message("Something you wanna show")`|
|list()|                        `list(APPEND VALUE_NAME VALUE)`|
|include_directories()||
|file()|                        `file(GLOB_RECURSE SOURCE_FILES_ALL RELATIVE "CMAKE_BASE_FROM_DIR" *.cpp *.c *.cc`)
|get_filename_component()|      `get_filename_component(TARGET_NAME SRC_NAME NAME)`|
|string()|                      `string(REPLACE " " "_" TARGET_NAME {TARGET_NAME}`)
|add_executable()|              `add_executable(${TARGET_NAME} ${CMAKE_BASE_FROM_DIR} ${SOURCE_FILES_ALL})`|
|add_library() |                `add_library({TARGET_NAME} STATIC {CMAKE_BASE_FROM_DIR} {SOURCE_FILES_ALL})`|
|target_link_libraries()|       `target_link_libraries({TARGET_NAME} {LINKFLAGS})`|
|find_package()|                `find_package(OpenCV 2.4.9 REQUIRED core highgui)`|
|set_property()|                `set_property( GLOBAL APPEND PROPERTY APPS2COMPILE  "VALUE")`|
|get_property()|                `get_property(LIBS2COMPILE GLOBAL PROPERTY LIBS2COMPILE)`|
|add_subdirectory()|            `add_subdirectory(src)`|


### 1.5. CMake常用语法
#### 1.5.1. 基本语法
* set(Foo a b c) 
* set(Foo "a b c")
* $ENV{VAR}
* set(ENV{VAR} /home}
* 
#### 1.5.1. if(TRUE|FALSE) ... elseif() ... else() ... endif()

| 命令名        | 变量说明      |
| ------------- |:-------------:|
|NOT|                           逆运算|
|STREQUAL|                      值是否相等|
|EXISTS|                        判断是否存在|
#### 1.5.2. foreach(VAR a b c) ... endforeach()

#### 1.5.3. macro(MACRO_FUNCTION_NAME [PARAMETERS]) ... endmacro()


#### 1.5.4. function(FUNCTION_NAME PARAMETERS) ... return() ... endfunction()
函数可以返回，可以用 return()命令返回。如果要从函数中返回值，只能通过参数返回：
```
#定义函数 get_lib从给定的目录查找指定的库，并把它传回到参数 lib_FILE中

function(get_lib lib_FILE lib_NAME lib_PATH)
       #message("lib_name:""${lib_NAME}")
       set(__LIB "__LIB-NOTFOUND")
       #message("__LIB:""${__LIB}")

       find_library(__LIB ${lib_NAME} ${lib_PATH})

       if(__LIB STREQUAL "__LIB-NOTFOUND")
              message("don't find ${lib_NAME} librarys in ${lib_PATH}")
              return()
       endif()

       #message("__LIB:""${__LIB}")
       set(${lib_FILE} ${__LIB}PARENT_SCOPE)
endfunction(get_lib)


```
set命令中 PARENT_SCOPE表示传递给函数调用者所拥有的变量



