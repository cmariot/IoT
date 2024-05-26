BOX_NAME = "bento/ubuntu-24.04"


up:
	vagrant up

stop:
	vagrant halt cmariotS

restart:
	vagrant reload cmariotS

clean:
	vagrant destroy -f cmariotS

fclean: clean
	vagrant box remove $(BOX_NAME)

re: clean up

status:
	vagrant status