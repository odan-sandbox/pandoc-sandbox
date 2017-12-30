FROM ubuntu:18.04

RUN apt update && \
    apt install -y texlive texlive-latex-extra texlive-bibtex-extra texlive-lang-japanese && \
    apt install -y locales zlib1g-dev xz-utils gcc make haskell-stack --no-install-recommends && \
    apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN locale-gen ja_JP.UTF-8
ENV TZ Asia/Tokyo

ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN mv /tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini

ENV SHELL=/bin/bash \
    NB_USER=user \
    NB_UID=1000 \
    NB_GID=100 \
    LANG=ja_JP.UTF-8 \
    LANGUAGE=ja_JP.UTF-8
ENV HOME=/home/$NB_USER
ENV PATH=$HOME/.local/bin:$PATH

ADD fix-permissions /usr/local/bin/fix-permissions
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    mkdir $HOME/work && \
    fix-permissions $HOME
USER $NB_USER

RUN mkdir -p $HOME/.stack/global-project
ADD stack.yaml $HOME/.stack/global-project
RUN stack setup && \
    stack install pandoc-1.19.2.4 pandoc-citeproc-0.10.5.1 pandoc-crossref-0.2.7.0 && \
    rm -rf $HOME/.stack

WORKDIR /home/user/work

ENTRYPOINT ["tini", "--"]
CMD ["run.sh"]
COPY run.sh /usr/local/bin/
