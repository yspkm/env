FROM ubuntu:jammy-20240227

ARG TZ
ARG JULIA_RELEASE
ARG JULIA_VERSION
ARG JULIA_TAR_GZ
ARG JUPYTER_PASSWORD

# CUDA 설치 경로 
ENV PATH="/cuda/bin:${PATH}"
ENV LD_LIBRARY_PATH="/cuda/lib64:${LD_LIBRARY_PATH}"
 
RUN rm -f /etc/apt/sources.list.d/*.list
COPY requirements.txt .
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        build-essential \
        wget \
        vim \
        curl \
        ssh \
        tree \
        git \
        libgl1-mesa-glx \
        libglib2.0-0 \
        zip \
        unzip \
	graphviz \
	libgraphviz-dev \
        python3 \
        python3-dev \
        python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade setuptools pip && \
    pip3 install torch torchvision torchaudio torchtext --index-url https://download.pytorch.org/whl/cu121 && \
    pip3 install -r requirements.txt 

RUN wget http://cdn.naver.com/naver/NanumFont/fontfiles/NanumFont_TTF_ALL.zip && \
    wget https://github.com/naver/nanumfont/releases/download/VER2.5/NanumGothicCoding-2.5.zip && \
	unzip NanumFont_TTF_ALL.zip && \
	unzip NanumGothicCoding-2.5.zip && \
	mkdir -p /usr/share/fonts/truetype/nanum && \
	mv *.ttf /usr/share/fonts/truetype/nanum/

RUN wget https://julialang-s3.julialang.org/bin/linux/x64/${JULIA_RELEASE}/${JULIA_TAR_GZ} && \
    tar -xvzf ${JULIA_TAR_GZ} && \
    cp -r julia-${JULIA_VERSION} /opt/ && \
    ln -s /opt/julia-${JULIA_VERSION}/bin/julia /usr/local/bin/julia && \
    rm ${JULIA_TAR_GZ} && \
	julia -e 'using Pkg; Pkg.add("SymEngine"); Pkg.add("IJulia"); Pkg.add("LanguageServer");'

RUN jupyter notebook --generate-config && \
    JUPYTER_PASSWORD_SHA1=`python3 -c \
        "import os; \
        from jupyter_server.auth import passwd; \
        print(passwd('${JUPYTER_PASSWORD}', 'sha1'));"` && \
    echo "c.NotebookApp.password = u'$JUPYTER_PASSWORD_SHA1'" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.allow_root = True" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.open_browser = False" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.password_required = True" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.use_redirect_file = False" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.FileContentsManager.delete_to_trash = False" >> /root/.jupyter/jupyter_notebook_config.py

RUN mkdir -p /root/.jupyter/lab/user-settings/@jupyterlab/apputils-extension && \
    echo '{ \
        "theme": "JupyterLab Dark", \
        "theme-scrollbars": true, \
        "overrides": { \
            "code-font-family": "NanumGothicCoding", \
            "code-font-size": "110%", \
            "content-font-family": null, \
            "content-font-size1": null, \
            "ui-font-family": null, \
            "ui-font-size1": null \
        } \
    }' > /root/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings

WORKDIR /workspace
