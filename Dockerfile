# our base image
FROM python:3.9-bullseye

# install awscli
RUN apt-get update -y
RUN apt-get install awscli -y

# install python packages
WORKDIR /usr/src/app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install jupyterlab

# install jupyter themes
# install nodejs for jupyter themes
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs
RUN jupyter labextension install @arbennett/base16-summerfruit-light
RUN jupyter labextension install @arbennett/base16-solarized-dark

#RUN jupyter labextension install @arbennett/base16-nord
#RUN jupyter labextension install @arbennett/base16-gruvbox-dark
#RUN jupyter labextension install @arbennett/base16-outrun
#RUN jupyter labextension install @arbennett/base16-mexico-light
#RUN jupyter labextension install @arbennett/base16-gruvbox-light
#RUN jupyter labextension install @arbennett/base16-solarized-light
#RUN jupyter labextension install @arbennett/base16-monokai
#RUN jupyter labextension install @arbennett/base16-one-dark

# Install R
# RUN apt install dirmngr gnupg apt-transport-https ca-certificates software-properties-common -y
# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
# RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
# RUN apt install r-base -y
# RUN R -e 'install.packages(c("IRkernel", "tidyverse", "tidymodels"), repos="http://cran.rstudio.com")'
# RUN R -e 'IRkernel::installspec(user = FALSE)'

#####################
#
# FISH SHELL SETUP
#
#####################
# add user with fish shell
RUN apt-get install fish sudo -y
RUN useradd -m -d /home/jupyter -s /usr/bin/fish jupyter
RUN usermod -s /usr/bin/fish jupyter
RUN adduser jupyter sudo
# make fish shell default for jupyter
RUN echo "jupyter     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN mkdir /etc/jupyter
RUN echo "c.NotebookApp.terminado_settings = { \"shell_command\": [\"/usr/bin/fish\"] }" >> /etc/jupyter/jupyter_notebook_config.py
# setup fish prompt and greeting
RUN git clone https://github.com/sciarrilli/fish_shell_things.git
RUN mkdir -p /home/jupyter/.config/fish/functions
RUN cp fish_shell_things/fish_prompt.fish /home/jupyter/.config/fish/functions
RUN cp fish_shell_things/fish_greeting.fish /home/jupyter/.config/fish/functions
RUN chown -R jupyter:jupyter /home/jupyter/.config/

# make fish shell default for root
RUN usermod -s /usr/bin/fish root
RUN mkdir -p /root/.config/fish/functions
RUN cp fish_shell_things/fish_prompt.fish /root/.config/fish/functions
RUN cp fish_shell_things/fish_greeting.fish /root/.config/fish/functions
RUN rm -rf fish_shell_things

#SHELL ["/usr/bin/fish", "-c"]
USER jupyter
RUN mkdir -p ~/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/
RUN echo "{\"theme\": \"base16-solarized-dark\"}" > ~/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings
#CMD ["/bin/bash"]
CMD ["jupyter-lab", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token=''", "--no-browser"]