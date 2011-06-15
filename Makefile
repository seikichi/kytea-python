all:
	swig -Wall -c++ -python -shadow -c++ kytea.i
	python setup.py build

clean:
	rm -f *_wrap.cxx kytea.py