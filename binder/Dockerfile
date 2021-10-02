FROM julia:1.6.3

# create user with a home directory
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

USER root

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    python3 \
    python3-dev \
    python3-distutils \
    curl \
    ca-certificates \
    git \
    zip \
    && \
    apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* # clean up


# We need install jupyterlab with sudo user, NOT ${USER}
RUN curl -kL https://bootstrap.pypa.io/get-pip.py | python3 && \
    pip3 install \
    jupyterlab \
    notebook \
    jupytext

USER ${USER}

RUN mkdir -p ${HOME}/.julia/config && \
    echo '\
# set environment variables\n\
ENV["PYTHON"]=Sys.which("python3")\n\
ENV["JUPYTER"]=Sys.which("jupyter")\n\
' >> ${HOME}/.julia/config/startup.jl && cat ${HOME}/.julia/config/startup.jl

RUN pip install webio_jupyter_extension && \
    julia -e '\
              using Pkg; \
              Pkg.add(PackageSpec(name="IJulia",version="1.23.2")); \
              Pkg.add(PackageSpec(name="Interact", version="0.10.3")); \
              Pkg.add(PackageSpec(name="WebIO", version="0.8.16")); \
              Pkg.pin(["IJulia", "Interact", "WebIO"]); \
              using IJulia, WebIO; \
              installkernel("Julia");\
              ' && \
    echo "Done"

ENV JULIA_PROJECT ${HOME}

WORKDIR ${HOME}
USER ${USER}
