#!/usr/bin/env python

from setuptools import setup, find_packages

setup(
    name='Beyond ETL',
    version='0.1',
    description='Beyond ETL',
    author='Liz Liu',
    author_email='lissyyang.liu@gmail.com',
    url='http://www.github.com/lizliu01',
    packages=find_packages(),
    long_description="""\
      TBD
      """,
    classifiers=[
        "Programming Language :: Python",
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
    ],
    keywords='etl pipeline aws',
    license='GPL',
    install_requires=[
        'boto3',
    ],
)