build:
	docker build -t planutils_server .

run:
	xhost +si:localuser:root >> /dev/null
	docker run \
		-it \
		--rm \
		-e DISPLAY \
    	-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
		-v ${PWD}:/scripts \
		--privileged \
		--runtime nvidia \
		--network host \
  		--gpus all \
		--name planutils_server \
		planutils_server \
		bash -c "python3 /scripts/planutils_server.py"