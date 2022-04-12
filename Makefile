.PHONY: deps test

deps:
	pip install -r requirements.txt

#lint:
#	flake8 nbp.robot

run:
	PYTHONPATH=. robot nbp.robot

#test:
#	PYTHONPATH=. py.test --verbose -s
#
#docker_build:
#	docker build -t hello-world-printer .
