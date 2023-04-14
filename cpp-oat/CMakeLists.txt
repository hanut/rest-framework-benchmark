cmake_minimum_required(VERSION 3.1)

set(project_name simple-http) ## rename your project here

project(${project_name})

set(CMAKE_CXX_STANDARD 11)

add_library(${project_name}-lib
        src/AppComponent.hpp
        src/controller/Controller.cpp
        src/controller/Controller.hpp
        src/controller/Dtos.hpp
)

## link libs

find_package(oatpp 1.3.0 REQUIRED)

target_link_libraries(${project_name}-lib
        PUBLIC oatpp::oatpp
        PUBLIC oatpp::oatpp-test
)

target_include_directories(${project_name}-lib PUBLIC src)

## add executables

add_executable(${project_name}
        src/App.cpp)
target_link_libraries(${project_name} ${project_name}-lib)
add_dependencies(${project_name} ${project_name}-lib)

target_link_libraries(${project_name}-lib)
add_dependencies(${project_name}-lib ${project_name}-lib)

set_target_properties(${project_name}-lib ${project_name} PROPERTIES
        CXX_STANDARD 11
        CXX_EXTENSIONS OFF
        CXX_STANDARD_REQUIRED ON
)