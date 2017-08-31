# CMake

---

## 1. CMake简介

### 1.1. CMake是神马？
CMake是一个跨平台的安装（编译）工具，可以用简单的语句来描述所有平台的安装(编译过程)。他能够输出各种各样的makefile或者project文件，能测试编译器所支持的C++特性,类似UNIX下的automake。只是 CMake 的组态档取名为 CmakeLists.txt。Cmake 并不直接建构出最终的软件，而是产生标准的建构档（如 Unix 的 Makefile 或 Windows Visual C++ 的 projects/workspaces），然后再依一般的建构方式使用。这使得熟悉某个集成开发环境（IDE）的开发者可以用标准的方式建构他的软件，这种可以使用各平台的原生建构系统的能力是 CMake 和 SCons 等其他类似系统的区别之处。

## 2. CMake安装
Linux平台安装：只需要使用一个简单的命令：

        sudo apt-get install cmake

Windows平台安装：可在官网(http://www.cmake.org)上直接下载最新的CMake版本并安装。

## 3. CMake使用
### 3.1. 利用CMake编译简单程序
例如对于依赖Qt的简单程序，其CMakeLists.txt可以这样编写(见cmake/learn/testCMakeApp)：

```
# + testCMakeApp
# -- main.cpp
# -- CMakeLists.txt

cmake_minimum_required(VERSION 2.8) 
project(testCMakeApp)

set(CMAKE_AUTOMOC ON)

find_package(Qt4 REQUIRED) # find Qt4

include_directories(${QT_INCLUDES})
add_executable(${PROJECT_NAME} main.cpp)
target_link_libraries(${PROJECT_NAME} Qt4::QtGui Qt4::QtXml)
```
### 3.2. 利用CMake编译简单库
例如对于依赖OpenCV的简单库，其CMakeLists.txt可以这样编写(见cmake/learn/testCMakeLib)：
```
# + testCMakeLib
# -- showImage.cpp
# -- showImage.h
# -- CMakeLists.txt

cmake_minimum_required(VERSION 2.8)
project(showImage)

find_package(OpenCV REQUIRED) # find OpenCV

include_directories(${OPENCV_INCLUDES})
add_library(${PROJECT_NAME} SHARED showImage.cpp)
target_link_libraries(${PROJECT_NAME} opencv_highgui)
```

### 3.2. 利用CMake编译复杂库
此部分可参考OpenCV，POCO等库的做法，也可以参考本路径使用PICMake的做法。

## 4. 附录

### 4.1. CMake常用变量
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

### 4.2. CMake常用命令
| 命令名        |
| ------------- |
|`project(<PROJECT-NAME> [LANGUAGES] [<language-name>...])`<br>`project(<PROJECT-NAME>`<br>`　　　　　[VERSION <major>[.<minor>[.<patch>[.<tweak>]]]]`<br>`　　　　　[LANGUAGES <language-name>...])`
|`set(<variable> <value>`<br> `　[[CACHE <type> <docstring> [FORCE]] \| PARENT_SCOPE])` <br> `set(<variable> <value1> ... <valueN>)`|
|`unset(<variable> [CACHE \| PARENT_SCOPE])` <br> `unset(ENV{LD_LIBRARY_PATH})`|
|`include(<file\|module> [OPTIONAL] [RESULT_VARIABLE <VAR>]` <br> `　　　　　　　　　　　　 [NO_POLICY_SCOPE])`| 
|`cmake_minimum_required(VERSION major[.minor[.patch[.tweak]]]`<br>` 　　　　　　　　　　　　　  [FATAL_ERROR])`<br>`cmake_policy(VERSION major[.minor[.patch[.tweak]]])`| 设置CMake版本要求`cmake_minimum_required(VERSION 2.8.6)`|
|`message([<mode>] "message to display" ...)` `STATUS`, `WARNING`, `AUTHOR_WARNING`， `SEND_ERROR`， `FATAL_ERROR`， `DEPRECATION`|                     `message("Something you wanna show")`|
|`list(LENGTH <list> <output variable>)`<br>`list(GET <list> <element index> [<element index> ...]`<br>`　　　<output variable>)`<br>`list(APPEND <list> [<element> ...])`<br>`list(FIND <list> <value> <output variable>)`<br>`list(INSERT <list> <element_index> <element> [<element> ...])`<br>`list(REMOVE_ITEM <list> <value> [<value> ...])`<br>`list(REMOVE_AT <list> <index> [<index> ...])`<br>`list(REMOVE_DUPLICATES <list>)`<br>`list(REVERSE <list>)`<br>`list(SORT <list>)`|
|`include_directories([AFTER\|BEFORE] [SYSTEM] dir1 [dir2 ...])`|
|`file(WRITE filename "message to write"... )`<br>`file(APPEND filename "message to write"... )`<br>`file(READ filename variable [LIMIT numBytes] [OFFSET offset] [HEX])`<br>`file(<MD5\|SHA1\|SHA224\|SHA256\|SHA384\|SHA512> filename variable)`<br>`file(STRINGS filename variable [LIMIT_COUNT num]`<br>`　　　[LIMIT_INPUT numBytes] [LIMIT_OUTPUT numBytes]`<br>`　　　[LENGTH_MINIMUM numBytes] [LENGTH_MAXIMUM numBytes]`<br>`　　　[NEWLINE_CONSUME] [REGEX regex]`<br>`     　　　[NO_HEX_CONVERSION])`<br>`file(GLOB variable [RELATIVE path] [globbing expressions]...)`<br>`file(GLOB_RECURSE variable [RELATIVE path]`<br>`　　　[FOLLOW_SYMLINKS] [globbing expressions]...)`<br>`file(RENAME <oldname> <newname>)`<br>`file(REMOVE [file1 ...])`<br>`file(REMOVE_RECURSE [file1 ...])`<br>`file(MAKE_DIRECTORY [directory1 directory2 ...])`<br>`file(RELATIVE_PATH variable directory file)`<br>`file(TO_CMAKE_PATH path result)`<br>`file(TO_NATIVE_PATH path result)`<br>`file(DOWNLOAD url file [INACTIVITY_TIMEOUT timeout]`<br>`　　　[TIMEOUT timeout] [STATUS status] [LOG log] [SHOW_PROGRESS]`<br>`　　　[EXPECTED_HASH ALGO=value] [EXPECTED_MD5 sum]`<br>`　　　[TLS_VERIFY on\|off] [TLS_CAINFO file])`<br>`file(UPLOAD filename url [INACTIVITY_TIMEOUT timeout]`<br>`　　　[TIMEOUT timeout] [STATUS status] [LOG log] [SHOW_PROGRESS])`<br>`file(TIMESTAMP filename variable [<format string>] [UTC])`<br>`file(GENERATE OUTPUT output_file`<br>`　　　<INPUT input_file\|CONTENT input_content>`<br>`　　　[CONDITION expression])`|                        `file(GLOB_RECURSE SOURCE_FILES_ALL RELATIVE "CMAKE_BASE_FROM_DIR" *.cpp *.c *.cc`)
|`get_filename_component(<VAR> <FileName> <COMP> [CACHE])`<br>`DIRECTORY` = Directory without file name<br>`NAME`      = File name without directory<br>`EXT`       = File name longest extension (.b.c from d/a.b.c)<br>`NAME_WE`   = File name without directory or longest extension<br>`ABSOLUTE`  = Full path to file<br>`REALPATH`  = Full path to existing file with symlinks resolved<br>`PATH`      = Legacy alias for DIRECTORY (use for CMake <= 2.8.11)|   
|`string(REGEX MATCH <regular_expression> `<br>`　　　　<output variable> <input> [<input>...])`<br>`string(REGEX MATCHALL <regular_expression>`<br>`　　　　<output variable> <input> [<input>...])`<br>`string(REGEX REPLACE <regular_expression>`<br>`    　　　　<replace_expression> <output variable>`<br>`　　　　<input> [<input>...])`<br>`string(REPLACE <match_string>`<br>` 　　　　<replace_string> <output variable>`<br>`　　　　<input> [<input>...])`<br>`string(CONCAT <output variable> [<input>...])`<br>`string(<MD5\|SHA1\|SHA224\|SHA256\|SHA384\|SHA512>`<br>`　　　　 <output variable> <input>)`<br>`string(COMPARE EQUAL <string1> <string2> <output variable>)`<br>`string(COMPARE NOTEQUAL <string1> <string2> <output variable>)`<br>`string(COMPARE LESS <string1> <string2> <output variable>)`<br>`string(COMPARE GREATER <string1> <string2> <output variable>)`<br>`string(ASCII <number> [<number> ...] <output variable>)`<br>`string(CONFIGURE <string1> <output variable>`<br>`　　　　[@ONLY] [ESCAPE_QUOTES])`<br>`string(TOUPPER <string1> <output variable>)`<br>`string(TOLOWER <string1> <output variable>)`<br>`string(LENGTH <string> <output variable>)`<br>`string(SUBSTRING <string> <begin> <length> <output variable>)`<br>`string(STRIP <string> <output variable>)`<br>`string(RANDOM [LENGTH <length>] [ALPHABET <alphabet>]`<br>`　　　　[RANDOM_SEED <seed>] <output variable>)`<br>`string(FIND <string> <substring> <output variable>`<br>`　　　　[REVERSE])`<br>`string(TIMESTAMP <output variable> [<format string>] [UTC])`<br>`string(MAKE_C_IDENTIFIER <input string> <output variable>)`|
|`add_executable(<name> [WIN32] [MACOSX_BUNDLE]`<br>`　　　　　　　　 [EXCLUDE_FROM_ALL]`<br>`　　　　　　　　 source1 [source2 ...])`<br>`add_executable(<name> IMPORTED [GLOBAL])`<br>`add_executable(<name> ALIAS <target>)`|
|`add_library(<name> [STATIC \| SHARED \| MODULE]`<br>`　　　　　　 [EXCLUDE_FROM_ALL]`<br>`　　　　　 　source1 [source2 ...])`<br>`add_library(<name> <SHARED\|STATIC\|MODULE\|UNKNOWN> IMPORTED`<br>`　　　　　 　[GLOBAL])`<br>`add_library(<name> OBJECT <src>...)`<br>`add_library(<name> ALIAS <target>)`<br>`add_library(<name> INTERFACE [IMPORTED [GLOBAL]])`|
|`target_link_libraries(<target> [item1 [item2 [...]]]`<br>`　　　　　 　　　　　　　  [[debug\|optimized\|general] <item>] ...)`<br>`target_link_libraries(<target>`<br>`                    　　　　　 　　　　　　　  <PRIVATE\|PUBLIC\|INTERFACE> <lib> ...`<br>`　　　　　 　　　　　　　  [<PRIVATE\|PUBLIC\|INTERFACE> <lib> ... ] ...])`

```
find_package(<package> [version] [EXACT] [QUIET] [MODULE]
             [REQUIRED] [[COMPONENTS] [components...]]
             [OPTIONAL_COMPONENTS components...]
             [NO_POLICY_SCOPE])
             
set_property(<GLOBAL                            |
              DIRECTORY [dir]                   |
              TARGET    [target1 [target2 ...]] |
              SOURCE    [src1 [src2 ...]]       |
              TEST      [test1 [test2 ...]]     |
              CACHE     [entry1 [entry2 ...]]>
             [APPEND] [APPEND_STRING]
             PROPERTY <name> [value1 [value2 ...]])

get_property(<variable>
             <GLOBAL             |
              DIRECTORY [dir]    |
              TARGET    <target> |
              SOURCE    <source> |
              TEST      <test>   |
              CACHE     <entry>  |
              VARIABLE>
             PROPERTY <name>
             [SET | DEFINED | BRIEF_DOCS | FULL_DOCS])
             
add_subdirectory(source_dir [binary_dir]
                 [EXCLUDE_FROM_ALL])
```

### 4.3. CMake常用语法

#### 4.3.1. 基本语法
* set(Foo a b c) 
* set(Foo "a b c")
* $ENV{VAR}
* set(ENV{VAR} /home}

#### 4.3.2. if(TRUE|FALSE) ... elseif() ... else() ... endif()
True if the constant is 1, ON, YES, TRUE, Y, or a non-zero number. False if the constant is 0, OFF, NO, FALSE, N, IGNORE, NOTFOUND, the empty string, or ends in the suffix -NOTFOUND. Named boolean constants are case-insensitive. If the argument is not one of these constants, it is treated as a variable.

判断表达式中常用的指令:

| 命令名        | 变量说明      |
| ------------- |:-------------:|
|NOT|               True if the expression is not true|
|AND|               True if both expressions would be considered true individually|
|OR|                True if either expression would be considered true individually|
|COMMAND|           True if the given name is a command, macro or function that can be invoked|
|POLICY|            True if the given name is an existing policy|
|TARGET|            True if the given name is an existing logical target name such as those created by the add_executable(), add_library(), or add_custom_target() commands}|
|EXISTS|            True if the named file or directory exists. Behavior is well-defined only for full paths|
|IS_DIRECTORY|      True if the given name is a directory. Behavior is well-defined only for full paths|
|IS_SYMLINK|        True if the given name is a symbolic link. Behavior is well-defined only for full paths|
|IS_ABSOLUTE|       True if the given path is an absolute path|
|MATCHES|           `if(<variable\|string> MATCHES regex)` True if the given string or variable’s value matches the given regular expression|
|LESS|              True if the given string or variable’s value is a valid number and less than that on the right|
|GREATER|           True if the given string or variable’s value is a valid number and greater than that on the right|
|EQUAL|             True if the given string or variable’s value is a valid number and equal to that on the right|
|STRLESS|           True if the given string or variable’s value is lexicographically less than the string or variable on the right|
|STRGREATER|        True if the given string or variable’s value is lexicographically greater than the string or variable on the right|
|STREQUAL|          True if the given string or variable’s value is lexicographically equal to the string or variable on the right|
|VERSION_LESS|      Component-wise integer version number comparison (version format is major[.minor[.patch[.tweak]]]|
|VERSION_EQUAL|     Component-wise integer version number comparison (version format is major[.minor[.patch[.tweak]]])|
|VERSION_GREATER|   Component-wise integer version number comparison (version format is major[.minor[.patch[.tweak]]])|
|DEFINED|       True if the given variable is defined. It does not matter if the variable is true or false just if it has been set. (Note macro arguments are not variables.)|

#### 4.3.3. foreach(VAR a b c) ... endforeach()

#### 4.3.4. macro(MACRO_FUNCTION_NAME [PARAMETERS]) ... endmacro()


#### 4.3.5. function(FUNCTION_NAME PARAMETERS) ... return() ... endfunction()
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



