BOX_NAME = "bento/ubuntu-24.04"


up:
	vagrant up

stop:
	vagrant halt wloS
	vagrant halt cmariotSW

restart:
	vagrant reload wloS
	vagrant reload cmariotSW

help:
	vagrant global-status
	vagrant port wloS
	vagrant port cmariotSW
	vagrant --help

clean:
	vagrant destroy -f wloS
	vagrant destroy -f cmariotSW

fclean:
	vagrant destroy -f wloS
	vagrant destroy -f cmariotSW
	vagrant box remove $(BOX_NAME)
