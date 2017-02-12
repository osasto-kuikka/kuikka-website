install: create-dir create-home unpack add-service add-conf

update: stop-service remove-dir create-dir unpack start-service

uninstall: stop-service remove-service remove-dir

create-home:
	mkdir -p /var/lib/kuikka-website
	mkdir -p /var/lib/kuikka-website/wiki
	git init /var/lib/kuikka-website/wiki

create-dir:
	mkdir -p /opt/kuikka-website

remove-dir:
	rm -rf /opt/kuikka-website

unpack:
	tar zxvf kuikka_website.tar.gz -C /opt/kuikka-website

add-service:
	cp kuikka-website.service /usr/lib/systemd/system/
	systemctl daemon-reload

remove-service:
	rm /usr/lib/systemd/system/kuikka-website.service

start-service:
	systemctl start kuikka-website

stop-service:
	systemctl stop kuikka-website

add-conf:
	mkdir -p /etc/kuikka-website
	cp kuikka-website.conf /etc/kuikka-website/

remove-conf:
	rm -rf /etc/kuikka-website
