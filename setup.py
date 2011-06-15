#!/usr/bin/env python

from distutils.core import setup, Extension

example_module = Extension('_kytea',
                           sources=['kytea_wrap.cxx'],
                           libraries=["kytea"],
                           )

setup(name='kytea-python',
      version='0.1',
      author='seikichi',
      author_email='seikichi@kmc.gr.jp',
      ext_modules=[example_module],
      py_modules=['kytea'],
      )
