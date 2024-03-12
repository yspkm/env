FROM pytorch/pytorch:2.2.1-cuda12.1-cudnn8-runtime

ARG TZ
ARG JULIA_RELEASE
ARG JULIA_VERSION
ARG JULIA_TAR_GZ
ARG JUPYTER_PASSWORD
 
RUN rm -f /etc/apt/sources.list.d/*.list
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
        unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade setuptools pip && \
    pip install \
        jupyterlab \
        jupyterlab-vim \
        jupyterlab-code-formatter \
        jupyterlab-lsp \
        'python-lsp-server[all]' \
        black \
        isort \
        notebook \
        voila \
        scikit-learn \
        tensorboard \
        wandb \
        numpy \
        scipy \
        matplotlib \
        pandas \
        sympy \
        seaborn \
        plotly \
        dash \
        optuna \
        cupy-cuda12x \
        memory_profiler \
        pyarrow \
        ipywidgets

# Setup Fronts for Korean
RUN wget http://cdn.naver.com/naver/NanumFont/fontfiles/NanumFont_TTF_ALL.zip && \
    wget https://github.com/naver/nanumfont/releases/download/VER2.5/NanumGothicCoding-2.5.zip && \
	unzip NanumFont_TTF_ALL.zip && \
	unzip NanumGothicCoding-2.5.zip && \
	mkdir -p /usr/share/fonts/truetype/nanum && \
	mv *.ttf /usr/share/fonts/truetype/nanum/ && \
	cp /usr/share/fonts/truetype/nanum/Nanum* \
    	/opt/conda/lib/python3.10/site-packages/matplotlib/mpl-data/fonts/ttf/

# Install Julia 
RUN wget https://julialang-s3.julialang.org/bin/linux/x64/${JULIA_RELEASE}/${JULIA_TAR_GZ} && \
    tar -xvzf ${JULIA_TAR_GZ} && \
    cp -r julia-${JULIA_VERSION} /opt/ && \
    ln -s /opt/julia-${JULIA_VERSION}/bin/julia /usr/local/bin/julia && \
    rm ${JULIA_TAR_GZ} && \
	julia -e 'using Pkg; Pkg.add("SymEngine"); Pkg.add("IJulia"); Pkg.add("LanguageServer");'

# Setup Jupyter Notebook
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
    echo "c.NotebookApp.use_redirect_file = False" >> /root/.jupyter/jupyter_notebook_config.py

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

WORKDIR workspace
