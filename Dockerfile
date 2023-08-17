ARG PYTHON_VERSION=3.11
FROM python:${PYTHON_VERSION}-slim-bullseye AS build

COPY . /tmp/aws-cli-saml

RUN pip install --no-cache-dir /tmp/aws-cli-saml

FROM gcr.io/distroless/python3-debian11
ARG PYTHON_VERSION
ENV PYTHONPATH=/usr/local/lib/python${PYTHON_VERSION}/site-packages

RUN python -c "import os; os.makedirs('/usr/local/bin', exist_ok=True); os.symlink('/usr/bin/python', '/usr/local/bin/python')"

COPY --from=build /usr/local/lib/python${PYTHON_VERSION}/site-packages /usr/local/lib/python${PYTHON_VERSION}/site-packages

COPY --from=build /usr/local/bin/aws-saml /usr/local/bin/aws-saml

ENTRYPOINT [ "/usr/local/bin/aws-saml" ]
