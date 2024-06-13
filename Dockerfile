FROM node:lts

# Install Dependencies.
RUN apt-get update -y && \
    apt-get install -y \
        git \
        wget \
        curl \
        unzip \
        lib32stdc++6 \
        libglu1-mesa && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV FLUTTER_ROOT="/opt/flutter"
ENV PATH="${FLUTTER_ROOT}/bin:${PATH}"

# Set a default channel (branch)
ARG channel=stable

RUN git clone -b $channel https://github.com/flutter/flutter "${FLUTTER_ROOT}"
ENV PATH="${FLUTTER_ROOT}/bin:${PATH}"

# Disable analytics and crash reporting on the builder.
RUN flutter config --disable-analytics

# Perform a doctor run.
RUN flutter doctor -v

# Perform an artifact precache so that no extra assets need to be downloaded on demand.
RUN flutter precache --web

RUN npm install -g firebase-tools
