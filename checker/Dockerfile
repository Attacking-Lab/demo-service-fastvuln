FROM python:3.13-slim-bookworm

#RUN apk update && apk add git
RUN apt update && apt install -y git

COPY --from=docker.io/astral/uv:latest /uv /uvx /bin

WORKDIR /app

COPY uv.lock pyproject.toml .

RUN pip install --break-system-packages git-pass-helper==0.2.1
RUN --mount=type=secret,id=checker-pull-token \
	git-pass -U https://git.atklab.cloud -p "$(cat /run/secrets/checker-pull-token)" -- uv sync --frozen --exact

COPY main.py gunicorn.conf.py .

CMD ["uv", "run", "--no-sync", "gunicorn", "-c", "gunicorn.conf.py", "main:app"]
