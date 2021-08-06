# our base image
FROM ubuntu:xenial

RUN mkdir /home/dst
WORKDIR /home/dst

COPY requirements.txt requirements.txt

# python 3.9
RUN apt update
RUN apt install software-properties-common -y 
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt update
RUN apt install python3.9 python3.9-venv python3.9-dev python3-pip curl -y
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3.9 get-pip.py
RUN pip install -r requirements.txt
RUN pip install jupyterlab

RUN rm -rf requirements.txt
RUN rm -rf get-pip.py

#CMD ["/bin/bash"]
CMD ["jupyter-lab", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token=''", "--no-browser"]