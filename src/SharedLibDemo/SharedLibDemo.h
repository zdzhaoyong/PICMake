#include <iostream>

class SharedLibDemo
{
public:
	SharedLibDemo(std::string nm):name(nm){}
	
	void report();
	std::string name;
};
