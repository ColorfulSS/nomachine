FROM ubuntu:20.04


#ENV DEBIAN_FRONTEND=noninteractive

ENV NOMACHINE_PACKAGE_NAME nomachine_6.10.12_1_amd64.deb
ENV NOMACHINE_BUILD 6.10
ENV NOMACHINE_MD5 930ed68876b69a5a20f3f2b2c0650abc

# Helpers
RUN apt-get update && apt-get install -y vim xterm pulseaudio cups 

RUN apt-get -y dist-upgrade 
RUN apt-get install -y  mate-desktop-environment-core mate-desktop-environment mate-indicator-applet ubuntu-mate-themes ubuntu-mate-wallpapers chromium-browser firefox nano sudo

RUN apt-get install -y wget curl

RUN curl -fSL "http://download.nomachine.com/download/${NOMACHINE_BUILD}/Linux/${NOMACHINE_PACKAGE_NAME}" -o nomachine.deb \
&& echo "${NOMACHINE_MD5} *nomachine.deb" | md5sum -c - && dpkg -i nomachine.deb && sed -i "s|#EnableClipboard both|EnableClipboard both |g" /usr/NX/etc/server.cfg

RUN curl -s https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o google-chrome-stable_current_amd64.deb && \
    apt -y install ./google-chrome-stable_current_amd64.deb && \
    rm ./google-chrome-stable_current_amd64.deb

RUN apt-get clean
RUN apt-get autoclean

RUN echo 'pref("browser.tabs.remote.autostart", false);' >> /usr/lib/firefox/browser/defaults/preferences/vendor-firefox.js
RUN rm -rf /var/lib/apt/lists/*

EXPOSE 4000

VOLUME [ "/home/nomachine" ]

ADD nxserver.sh /

RUN chmod +x /nxserver.sh

ENTRYPOINT ["/nxserver.sh"]
