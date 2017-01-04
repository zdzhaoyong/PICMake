#include <iostream>

class StaticLibDemo
{
public:
	StaticLibDemo(std::string nm):name(nm){}
	
	void report();
	std::string name;
};
