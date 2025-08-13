# https://github.com/m-bers/broadway-baseimage/blob/main/Dockerfile
# FROM ubuntu:latest
# view latest: 2004-focal
FROM ubuntu:20.04

ENV GDK_BACKEND='broadway' \
  BROADWAY_DISPLAY=':5' \
  DARK_MODE='false' \
  GTK_THEME='Materia' \
  BG_GRADIENT="#ddd, #999"

RUN apt-get update; \
  apt-get install -y --no-install-recommends libgtk-3-0 libgtk-3-bin nginx gettext-base tmux wget materia-gtk-theme papirus-icon-theme; \
  apt-get clean && apt-get autoclean && rm -rf /var/lib/apt/lists/*; \
  rm -rf /usr/share/themes/Materia && mv /usr/share/themes/Materia-light /usr/share/themes/Materia

RUN \
  wget --no-check-certificate -O /usr/bin/ttyd "https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.$(uname -m)"; \
  chmod +x /usr/bin/ttyd

COPY conf/start.sh /usr/local/bin/start
COPY conf/nginx.tmpl /etc/nginx/nginx.tmpl
COPY conf/terminal-outline.svg /www/data/images/terminal-outline.svg
EXPOSE 80
# overwrite this with 'CMD []' in a dependent Dockerfile
# CMD ["/usr/local/bin/start"]


# FROM mber5/broadway-baseimage:latest
ENV HOSTS="[]" \
  APP_TITLE='Virtual Machine Manager' \
  FAVICON_URL='https://raw.githubusercontent.com/virt-manager/virt-manager/931936a328d22413bb663e0e21d2f7bb111dbd7c/data/icons/256x256/apps/virt-manager.png' \
  CORNER_IMAGE_URL='https://raw.githubusercontent.com/virt-manager/virt-manager/931936a328d22413bb663e0e21d2f7bb111dbd7c/data/icons/256x256/apps/virt-manager.png'

RUN apt-get update; \
  apt-get install -y --no-install-recommends virt-manager dbus-x11 libglib2.0-bin gir1.2-spiceclientgtk-3.0 ssh at-spi2-core; \
  apt-get clean && apt-get autoclean && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /root/.ssh; \
  echo "Host *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

# startapp> start
COPY startapp.sh /usr/local/bin/startapp
CMD ["/usr/local/bin/startapp"]
