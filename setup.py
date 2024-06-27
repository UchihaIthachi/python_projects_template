import io
import os
from setuptools import setup, find_packages

# Function to read the contents of a file
def read(*paths, **kwargs):
    with io.open(
        os.path.join(os.path.dirname(__file__), *paths),
        encoding=kwargs.get("encoding", "utf8"),
    ) as open_file:
        return open_file.read().strip()

# Read the version from the VERSION file
def read_version():
    version_file = os.path.join(os.path.dirname(__file__), "src", "VERSION")
    with io.open(version_file, encoding="utf-8") as f:
        version = f.read().strip()
    return version

# Function to read the requirements from a file
def read_requirements(path):
    return [
        line.strip()
        for line in read(path).split("\n")
        if not line.startswith(('"', "#", "-", "git+"))
    ]

setup(
    name="pythonassesment",
    version=read_version(),
    description="Awesome pythonassesment created by UchihaIthachi",
    url="https://github.com/UchihaIthachi/pythonAssesment/",
    long_description=read("README.md"),
    long_description_content_type="text/markdown",
    author="UchihaIthachi",
    packages=find_packages(exclude=["tests", ".github"]),
    install_requires=read_requirements("requirements.txt"),
    entry_points={
        'console_scripts': [
            'pythonassesment = pythonassesment.__main__:main',
        ],
    },
    classifiers=[
        'Programming Language :: Python :: 3',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
    ],
    python_requires='>=3.6',
)



# """Python setup.py for pythonassesment package"""
# import io
# import os
# from setuptools import find_packages, setup
# from setuptools import setup, find_packages

# setup(
#     name='healthcare_management',
#     version=open('healthcare_management/VERSION').read().strip(),
#     description='Healthcare Management System',
#     author='Your Name',
#     author_email='your.email@example.com',
#     packages=find_packages(include=['healthcare_management', 'healthcare_management.*']),
#     include_package_data=True,
#     install_requires=[
#         # Add your dependencies here
#         'flask',
#         'sqlalchemy',
#         'pytest',
#         'flask_sqlalchemy',
#         'flask_restful',
#         # more dependencies
#     ],
#     entry_points={
#         'console_scripts': [
#             'healthcare_management = healthcare_management.__main__:main',
#         ],
#     },
# )


# def read(*paths, **kwargs):
#     """Read the contents of a text file safely.
#     >>> read("src", "VERSION")
#     '0.1.0'
#     >>> read("README.md")
#     ...
#     """

#     content = ""
#     with io.open(
#         os.path.join(os.path.dirname(__file__), *paths),
#         encoding=kwargs.get("encoding", "utf8"),
#     ) as open_file:
#         content = open_file.read().strip()
#     return content


# def read_requirements(path):
#     return [
#         line.strip()
#         for line in read(path).split("\n")
#         if not line.startswith(('"', "#", "-", "git+"))
#     ]


# setup(
#     name="pythonassesment",
#     version=read("src", "VERSION"),
#     description="Awesome pythonassesment created by UchihaIthachi",
#     url="https://github.com/UchihaIthachi/pythonAssesment/",
#     long_description=read("README.md"),
#     long_description_content_type="text/markdown",
#     author="UchihaIthachi",
#     packages=find_packages(exclude=["tests", ".github"]),
#     install_requires=read_requirements("requirements.txt"),
#     entry_points={
#         "console_scripts": ["pythonassesment = pythonassesment.__main__:main"]
#     },
#     extras_require={"test": read_requirements("requirements-test.txt")},
# )
