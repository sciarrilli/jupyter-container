# Data Science Tools 1

This environment is setup for python 3.9 and the specific versions of libraries in requirements.txt which are compatible with python 3.9

## Steps to setup

1. install docker
2. cd dst_new_ver_py_libs
3. docker build -t jupyter .
4. docker run --rm -p 8888:8888 -v ~/Documents/Data\ Science/:/home/dst/ jupyter
5. open a browser to localhost:8888
