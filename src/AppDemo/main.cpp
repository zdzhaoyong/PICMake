#include <iostream>
#include "../SharedLibDemo/SharedLibDemo.h"
#include "../StaticLibDemo/StaticLibDemo.h"

int main(int argc,char** argv)
{
	std::cout<<"Compiled success!"<<std::endl;
        SharedLibDemo sharedDemo("SharedLibDemo");
        StaticLibDemo staticDemo("StaticLibDemo");
        sharedDemo.report();
        staticDemo.report();
	return 0;
}
