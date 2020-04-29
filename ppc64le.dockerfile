FROM alpine AS builder

# Download QEMU, see https://github.com/docker/hub-feedback/issues/1261
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-ppc64le.tar.gz
RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1


FROM ppc64le/python:3-alpine

# Add QEMU
COPY --from=builder qemu-ppc64le-static /usr/bin

# Install requirements
WORKDIR /usr/src/app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy application sources
COPY src .

# Run the application
ENV FLASK_APP=app.py
CMD [ "flask", "run" ]
