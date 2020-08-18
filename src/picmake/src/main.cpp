#include "Svar.h"
#include "filesystem.hpp"
#include "VecParament.h"

using namespace GSLAM;

std::string getName(){
    return GSLAM::filesystem::current_path().stem();
}

int main(int argc,char** argv)
{
    sv::Svar options;
    options.parseMain(argc,argv);

    std::string mode=options.arg<std::string>("m","bin","The target compile mode: bin,shared,static");
    std::string name=options.arg<std::string>("name",getName(),"The target name, default is the parent folder name");
    std::string requires=options.arg<std::string>("require","","The required dependencies");
    std::string srcs=options.arg<std::string>("src","src","The source cpp folders for files, eg: main.cpp,src");
    std::string standard=options.arg<std::string>("standard","11","The c++ standard wanna use");
    std::string build=options.arg<std::string>("build","","The folder to hold the build targets");
    std::string build_type=options.arg<std::string>("build_type","Release","CMAKE_BUILD_TYPE: Default, Release, Debug");
    bool        install=options.arg("install",true,"Auto generate install& uninstall");
    bool        version=options.arg("version",false,"Show version information");
    bool        force  =options.arg("force",false,"Force overwrite when CMakeLists.txt existed.");

    if(options.get("help",false)) return options.help();

    if(version){
        std::cout<<svar["__builtin__"]<<std::endl;
        return 0;
    }

    if(!force&&filesystem::exists("CMakeLists.txt")) {
        std::cout<<"CMakeLists.txt already exists, abort generating."<<std::endl;
        return 0;
    }

    std::stringstream sst;
    sst<<"cmake_minimum_required(VERSION 2.8)"<<std::endl;
    sst<<"project("<<name<<")"<<std::endl;
    sst<<"\ninclude(PICMake)"<<std::endl;

    sst<<"set(CMAKE_CXX_STANDARD "<<standard<<")"<<std::endl;

    sst<<"if(NOT CMAKE_BUILD_TYPE)"<<std::endl;
    sst<<"  set(CMAKE_BUILD_TYPE "<<build_type<<")"<<std::endl;
    sst<<"endif()\n"<<std::endl;

    sv::Svar requires_vec=VecParament<std::string>(requires).data;
    sv::Svar srcs_vec= VecParament<std::string>(srcs).data;

    for(auto& c:mode) c=toupper(c);

    sst<<"\npi_add_target("<<name<<" "<<mode;

    bool abortbuild=false;
    for(sv::Svar s:srcs_vec){
        if(!GSLAM::filesystem::exists(s.as<std::string>()))
        {
            std::cout<<"Can't find file or directory "<<s.as<std::string>()<<std::endl;
            abortbuild=true;
        }
        sst<<" "<<s.as<std::string>();
    }

    sst<<" REQUIRED System";
    for(sv::Svar s:requires_vec)
        sst<<" "<<s.as<std::string>();

    sst<<")\n";

    sst<<"\npi_report_target()";

    if(install){

        sst<<"\n\n# Now do make install";
        sst<<"\npi_install(TARGETS "<<name<<")";
    }


    std::cout<<sst.str()<<std::endl;
    std::ofstream ofs("CMakeLists.txt");
    ofs<<sst.str();

    if(build.size()&&!abortbuild){
       GSLAM::filesystem::create_directories(build);
       std::string cmd=("cd "+build+" ; cmake .. ; cmake --build .");
       std::cout<<cmd<<std::endl;
       std::cout<<std::system(cmd.c_str())<<std::endl;
//       cmd=("cmake --build "+build);
//       std::cout<<cmd<<std::endl;
//       std::cout<<std::system(cmd.c_str())<<std::endl;
    }

    return 0;
}
