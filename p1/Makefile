BOX_NAME = "bento/ubuntu-24.04"


up:
	vagrant up

stop:
	vagrant halt wloS
	vagrant halt cmariotSW

restart:
	vagrant reload wloS
	vagrant reload cmariotSW

clean:
	vagrant destroy -f wloS
	vagrant destroy -f cmariotSW
	rm -f confs/token

fclean: clean
	vagrant box remove $(BOX_NAME)

re: clean up

status:
	vagrant status
