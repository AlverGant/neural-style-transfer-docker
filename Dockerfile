FROM gcr.io/tensorflow/tensorflow:latest-gpu

MAINTAINER Alvaro Antelo <alvaro.antelo@gmail.com>

# Pick up some TF dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        ffmpeg \
        git \
        libcupti-dev \
        python \
        wget \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN pip --no-cache-dir install \
        Pillow \
        h5py \
        numpy \
        scipy

RUN pip --no-cache-dir install --upgrade \
        https://storage.googleapis.com/tensorflow/linux/cpu/protobuf-3.1.0-cp27-none-linux_x86_64.whl \
        tensorflow-gpu

# Install TensorFlow CPU version.
#RUN pip --no-cache-dir install \
        #https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.4.0-cp27-none-linux_x86_64.whl
# --- ~ DO NOT EDIT OR DELETE BETWEEN THE LINES --- #

RUN git clone https://github.com/lengstrom/fast-style-transfer && \
        cd fast-style-transfer && \
        wget -c https://d17h27t6h515a5.cloudfront.net/topher/2017/January/587d1865_rain-princess/rain-princess.ckpt && \
        wget -c https://d17h27t6h515a5.cloudfront.net/topher/2017/January/588aa800_la-muse/la-muse.ckpt && \
        wget -c https://d17h27t6h515a5.cloudfront.net/topher/2017/January/588aa846_udnie/udnie.ckpt && \
        wget -c https://d17h27t6h515a5.cloudfront.net/topher/2017/January/588aa883_scream/scream.ckpt && \
        wget -c https://d17h27t6h515a5.cloudfront.net/topher/2017/January/588aa89d_wave/wave.ckpt && \
        wget -c https://d17h27t6h515a5.cloudfront.net/topher/2017/January/588aa8b6_wreck/wreck.ckpt

# For CUDA profiling, TensorFlow requires CUPTI.
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH

# TensorBoard
EXPOSE 6006

WORKDIR "/notebooks/fast-style-transfer"

ENTRYPOINT ["python", "./evaluate.py"]

CMD ["--checkpoint", "./la-muse.ckpt", "--in-path", "/input/", "--out-path", "/output/", "--allow-different-dimensions"]