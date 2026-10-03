FROM python:3.13-slim-bookworm

#RUN apk update && apk add git
RUN apt update && apt install -y git

COPY --from=docker.io/astral/uv:latest /uv /uvx /bin

WORKDIR /app

RUN pip install --break-system-packages git-pass-helper==0.2.1
RUN --mount=type=cache,target=/root/.cache/uv \
	--mount=type=bind,source=uv.lock,target=uv.lock \
	--mount=type=bind,source=pyproject.toml,target=pyproject.toml \
	--mount=type=secret,id=checker-pull-token \
	git-pass -U https://git.atklab.cloud -p "$(cat /run/secrets/checker-pull-token)" -- \
		uv sync --frozen --exact --compile-bytecode --no-install-project

COPY uv.lock pyproject.toml main.py gunicorn.conf.py .

CMD ["uv", "run", "--no-sync", "gunicorn", "-c", "gunicorn.conf.py", "main:app"]
