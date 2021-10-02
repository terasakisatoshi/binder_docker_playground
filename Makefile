.phony : all, build, clean

DOCKERIMAGE=binderplaygroundjl

all: build

build:
	-rm -f Manifest.toml
	docker build -t ${DOCKERIMAGE} -f binder/Dockerfile . --build-arg NB_USER=jovyan --build-arg NB_UID=1000
	docker-compose build
	docker-compose run --rm julia julia --project=/work -e 'using Pkg; Pkg.instantiate()'

clean:
	docker-compose down
	-rm -f playground/notebook/*.ipynb
	-rm -rf playground/notebook/*.gif
	-rm -rf playground/notebook/*.png
