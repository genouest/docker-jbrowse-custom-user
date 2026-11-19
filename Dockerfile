FROM mambaorg/micromamba:latest AS micromamba

FROM nginx:1.31.9

COPY --from=micromamba /bin/micromamba /usr/local/bin/micromamba
ENV MAMBA_ROOT_PREFIX=/opt/conda
ENV PATH=/opt/conda/bin:$PATH

ENV DEBIAN_FRONTEND noninteractive

RUN mkdir -p /usr/share/man/man1 /usr/share/man/man7

RUN apt-get -qq update --fix-missing
RUN apt-get --no-install-recommends -y install build-essential zlib1g-dev libxml2-dev libexpat-dev postgresql-client libpq-dev libpng-dev wget unzip perl-doc ca-certificates

RUN micromamba create -y -p /conda \
        --override-channels \
        -c conda-forge -c bioconda \
        jbrowse=1.16.11 \
    && micromamba clean --all --yes

RUN ls -lha /conda/opt/jbrowse/

RUN rm -rf /usr/share/nginx/html && ln -s /conda/opt/jbrowse/ /usr/share/nginx/html && \
    ln -s /jbrowse/data /conda/opt/jbrowse/data && \
    sed -i '/include += {dataRoot}\/tracks.conf/a include += {dataRoot}\/datasets.conf' /conda/opt/jbrowse/jbrowse.conf && \
    sed -i '/include += {dataRoot}\/tracks.conf/a include += {dataRoot}\/../datasets.conf' /conda/opt/jbrowse/jbrowse.conf

ADD /scripts/ /scripts/
ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
