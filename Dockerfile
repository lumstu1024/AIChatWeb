FROM python:alpine as builder
RUN useradd -m 10001 && echo \"10001:10001\" | chpasswd && 10001 10001 sudo
USER 10001
RUN apk update && apk add  --no-cache tzdata ca-certificates
ADD requirements.txt /tmp/
RUN pip3 install --user -r /tmp/requirements.txt

FROM python:alpine
ENV TZ=Asia/Shanghai
WORKDIR /app
COPY . .
COPY --from=builder /root/.local /usr/local
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
EXPOSE 8000
CMD ["python","main.py"]
