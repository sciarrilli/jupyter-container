# our base image
FROM ubuntu:xenial

RUN mkdir /home/jupyter
WORKDIR /home/jupyter

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

# install nodejs for jupyter themes
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

# install jupyter themes
RUN jupyter labextension install @arbennett/base16-nord
RUN jupyter labextension install @arbennett/base16-gruvbox-dark
RUN jupyter labextension install @arbennett/base16-monokai
RUN jupyter labextension install @arbennett/base16-one-dark
RUN jupyter labextension install @arbennett/base16-outrun
RUN jupyter labextension install @arbennett/base16-solarized-dark
RUN jupyter labextension install @arbennett/base16-mexico-light
RUN jupyter labextension install @arbennett/base16-gruvbox-light
RUN jupyter labextension install @arbennett/base16-solarized-light
RUN jupyter labextension install @arbennett/base16-summerfruit-light

#CMD ["/bin/bash"]
CMD ["jupyter-lab", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token=''", "--no-browser"]