# PICMake （版本 1.2）

---

## 1. PICMake简介
### 1.1. PICMake是神马？
你还在学[CMake](./cmake/CMake.md)的过程中毫无头绪吗？你还在为复杂程序库依赖发愁吗？你是否觉得原生CMake的编写冗余而低效？那就快来学习和使用PICMake吧！只需要一行，无论是可执行，动态库还是静态库，轻松搞定！同时高效支持多目标，复杂库的编译安装，从此告别大量冗余CMake代码，专注开发核心应用程序，编译不再愁！
例如下面是使用PICMake编译一个依赖OpenGL的可执行文件，只需要一行！（第一行是加载PICMake，好吧，如果也要算那就是两行）：
```
include(PICMake)
pi_add_target(demo BIN src main.cpp REQUIRED OpenGL)
```
从此告别一堆罗嗦的find_package和其他冗余代码！

那么如何做到的呢？这一切的秘密都在*PICMake.cmake*这一个文件中哦,稍微啃一啃这个代码，绝对瞬间提高你对CMake的认识水平哦～好啦好啦，源码我们留给大家自己去深究，小编先给大家介绍PICMake的使用吧！

*注释：
由于CMake仍然有很多弹性，不够统一的风格可能导致相互之间的支持较差，因此导致用户的工作量增大。
可以认为PICMake其实是规定了一个使用CMake的标准,当用户按照此标准来使用CMake时，可以大大简化工作流程。PICMake目前主要针对Linux下的C++工程，目前主要集成了CV领域的常用库支持，我们将持续对其进行改进更新，也欢迎更多开发者提出更多的意见！*


### 1.2. PICMake的安装
好啦好啦，安装PICMake与使用CMake的过程完全一致，相信编译过CMake项目的娃子们一定不会陌生（嘿嘿～～），同时我们也建议大家使用下面的习惯来编译CMake项目哦：
```
mkdir build
cd build
cmake ..
make
sudo make install
```
实际上，PICMake本身核心只有一个文件，那就是cmake目录下面的那个，用户可以直接将它放在自己的项目中！为了让大家了解到PICMake的使用方式，我们把项目本身设计成了一个cmake工程，工程本身就是一个使用的例子哦～
对于安装后的PICMake，可使用`sudo make uninstall` 进行卸载，不要问我卸载是在哪里支持的，这是PICMake的秘密～～

#### 1.3. 目录结构
PICMake的目录结构如下：
```
+- PICMake
++- CMakeLists          -- PICMake安装文件与库示例
++- README.md           -- PICMake介绍文件
++- cmake               -- cmake相关
+++- PICMake.cmake.in   -- 安装支持文件
+++- PICMake.cmake      -- PICMake的主体文档
+++- CMake.md           -- CMake学习文档
+++- learn              -- 辅助学习的文件夹
+++- Find*.cmake        -- 依赖包寻找脚本
++- src                 -- 库框架示例
++- examples            -- 使用示例
```

## 2. PICMake的使用介绍
### 2.1. 使用PICMake编译简单可执行和库文件
在前面我们已经简单提到，使用PICMake只需要一行即可完成可执行和库编译，而实际上我们建议在加上固定的两行，标准的写法应该如下(例子详见`examples/0_simple_app`)：
```
cmake_minimum_required(VERSION 2.8)     # 添加原因： 新版本的cmake规定第一行应该声明版本需求
include(PICMake)                        # 加载PICMake支持，也可以直接include(cmake/PICMake.cmake)
pi_add_target(simple_library SHARED showImage.cpp REQUIRED OpenCV)# 编译依赖OpenCV的简单库
pi_report_target()                      # 添加原因： PICMake建议加上用于报告最终将被编译的目标
```
可以看到添加的两行基本上是比较固定的，第一行是CMake的规定，最后一行是用于报告将会被编译的目标文件。
这里用到的一个核心函数是`pi_add_target`,其用法是:

`pi_add_target(<name> <BIN/STATIC/SHARED> <src1/dir1　...>`<br>`　　　　　　　　 [MODULES module1 ...] `<br>`　　　　　　　　 [REQUIRED module1 ...]`<br>`　　　　　　　　 [DEPENDENCY target1 ...])`

第一个参数是目标名称，第二个参数是编译目标类型，第三个参数是要添加的源文件或文件夹，`MODULES`代表的是非必须第三方库列表，程序里可通过`#ifdef HAS_QT`宏选择性编译相关代码，`REQUIRED`代表必须的第三方库列表, `DEPENDENCY`代表当前目标所依赖的target。

### 2.2. 使用PICMake编译多个目标并安装
对于较大一些的工程，往往包含多个目标和库，同时可能包含需要安装的目标，而本项目本身就展示了这样一个工程的PICMake写法（详见本工程"CMakeLists.txt")：
```
cmake_minimum_required(VERSION 2.6)
project(PICMake)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/PICMake.cmake)# Use PICMake

if(FALSE) # Tree style
  add_subdirectory(src)
else()  # All in one
  pi_add_target(StaticLibDemo STATIC src/StaticLibDemo) # 静态库示例
  pi_add_target(SharedLibDemo SHARED src/SharedLibDemo) # 动态库示例
  pi_add_target(AppDemo BIN src/AppDemo DEPENDENCY StaticLibDemo SharedLibDemo REQUIRED OpenCV) # 依赖前两个库的可执行文件
  pi_add_target(ConditionalApp BIN src/ConditionalApp MODULES PIL Qt System REQUIRED OpenCV) #条件编译示例
endif()

pi_install(CMAKE ${PROJECT_SOURCE_DIR}/cmake/PICMake.cmake.in)# 安装文件示例，其中自动支持卸载
pi_report_target()
```
这里添加了一个`pi_install`函数，其详细用法为：

`pi_install([HEADERS header1/dir1 ...]`<br>`　　　　　　 [TARGETS target1 ...]`<br>`　　　　　　 [CMAKE cmake_config]`<br>`　　　　　　 [BIN_DESTINATION dir] `<br>`　　　　　　 [LIB_DESTINATION dir] `<br>`　　　　　　 [HEADER_DESTINATION dir])`

### 2.3. 编写PICMake支持的FindPackage.cmake
对于MODULES和REQUIRED中设定的每一个PACKAGE，PICMake都会调用`find_package`函数去寻找对应的FindPackge.cmake文档。其中FindPackage.cmake文档需要去寻找PACKAGE的头文件路径和库文件模块。
下表列出了FindPackage的主要输入变量：

| 变量名        | 变量说明      |
| ------------- |:-------------:|
|PACKAGE_FIND_NAME|             需要寻找的包名字|
|PACKAGE_FIND_VERSION|          需要寻找的包版本|
|PACKAGE_FIND_VERSION_MAJOR|    需要寻找的主版本号|
|PACKAGE_FIND_VERSION_MINOR|    需要寻找的次版本号|
|PACKAGE_FIND_VERSION_PATCH|    需要寻找的版本补丁号|
|PACKAGE_FIND_COMPONENTS|       需要寻找的组件|

对于指令`find_package(PIL 1.1.0 REQUIRED base cv）`， `PIL_FIND_NAME`即为PIL， `PIL_FIND_VERSION`为1.1.0， 其中`PIL_FIND_VERSION_MAJOR`为1, `PIL_FIND_VERSION_MINOR`为1, `PIL_FIND_VERSION_PATCH`为0， `PIL_FIND_COMPONENTS`为base和cv。
下表列出了FindPackage.cmake中需要给定的一些参数：

| 变量名        | 变量说明      |
| ------------- |:-------------:|
|PACKAGE_FOUND |                判断包PACKAGE是否被成功找到（TRUE,FALSE)|
|PACKAGE_VERSION |              返回包PACKAGE的版本号字符串|
|PACKAGE_VERSION_MAJOR |        查找到的主版本号|
|PACKAGE_VERSION_MINOR |        查找到的次版本号|
|PACKAGE_VERSION_PATCH |        查找到的版本补丁号|
|PACKAGE_INCLUDES|              同PACKAGE_INCLUDE_DIR,返回包的头文件地址|
|PACKAGE_LIBRARIES|             同PACKAGE_LIBRARY,PACKAGE_LIBS，返回包的库依赖|
|PACKAGE_DEFINITIONS|           返回包中需要的预编译定义|

其详细实现可参考FindPIL.cmake。

## 3. 内建函数和宏


| 函数（宏）名        | 函数说明      |
| ----- |:---|
|  `pi_collect_packagenames(<RESULT_NAME> [VERBOSE] [path1 ...]`)| Collect all available packages from "Find*.cmake"  files and put the result to RESULT_NAME.
| `pi_removesource(<VAR_NAME> <regex>)`| Remove all source files with name matches `<regex>`.
| `pi_hasmainfunc(<RESULT_NAME> source1 ...)`| Look for the source files with *main* function.
| `pi_add_target(<name> <BIN/STATIC/SHARED> <src1/dir1　...>`<br>`　　　　　　　　 [MODULES module1 ...] `<br>`　　　　　　　　 [REQUIRED module1 ...]`<br>`　　　　　　　　 [DEPENDENCY target1 ...])`|A combination of `add_executable` , `add_library`, `add_definitions` and `target_link_libraries`, `MODULES` includes packges or targets inessential and `REQUIRED` includes packages or target required,`DEPENDENCY` is used to include targets not defined and will be added after.
|`pi_add_targets([name1 ...])`| Add one or more targets, if one, please set `TARGET_NAME`, `TARGET_TYPE`, `TARGET_SRCS`, `TARGET_MODULES`, `TARGET_REQUIRED` and so on. If more than one target, replace `TARGET` with `${TARGET_NAME}`.
|`pi_report_target([LIBS2COMPILE] [APPS2COMPILE])`| Report all targets added.
|`pi_install([HEADERS header1/dir1 ...]`<br>`　　　　　　 [TARGETS target1 ...]`<br>`　　　　　　 [CMAKE cmake_config]`<br>`　　　　　　 [BIN_DESTINATION dir] `<br>`　　　　　　 [LIB_DESTINATION dir] `<br>`　　　　　　 [HEADER_DESTINATION dir])`| A combination of multi install commands and auto support `make install` and `make uninstall`.
|`pi_collect_packages(<RESULT_NAME> [VERBOSE] `<br>`　　　　　　　　　　　　[MODULES package1 ...]`<br>`　　　　　　　　　　　　[REQUIRED package1 package2 ...])`| Find multi packages with `find_package()` and collect available packages to `RESULT_NAME`. All packages will be checked and once with `VERBOSE` ON, all information will be reported.
|`pi_check_modules(module1 [module2 ...])`| Let module name to upper and make valid `_FOUND`, `_INCLUDES`, `_LIBRARIES`, `_DEFINITIONS`.
|`pi_report_modules(module1 [module2 ...])`| Report packages information summary.

## 4. CMake附录

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



