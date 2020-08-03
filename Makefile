.PHONY: load
load: load_dockersock load_systemd_docker_sock

.PHONY: load_dockersock
load_dockersock: dockersock.pp
	semodule -i $^

.PHONY: unload
unload: unload_dockersock unload_systemd_docker_sock

.PHONY: unload_dockersock
unload_dockersock:
	semodule -r dockersock

dockersock.mod: dockersock.te
	checkmodule -M -m $< -o $@

dockersock.pp: dockersock.mod
	semodule_package -m $< -o $@

.PHONY: load_systemd_docker_sock
load_systemd_docker_sock: systemd_docker_sock.pp
	semodule -i $^

.PHONY: unload_systemd_docker_sock
unload_systemd_docker_sock:
	semodule -r systemd_docker_sock

systemd_docker_sock.mod: systemd_docker_sock.te
	checkmodule -M -m $< -o $@

systemd_docker_sock.pp: systemd_docker_sock.mod
	semodule_package -m $< -o $@

.PHONY: clean
clean::
	rm -f dockersock.pp dockersock.mod systemd_docker_sock.pp systemd_docker_sock.mod
