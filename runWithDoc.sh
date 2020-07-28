#!/bin/bash

set -e


# copy this file into the root of your repository
# adjust to your needs

# This run.sh is intended for 3.0.0
VERSION=$(grep -Po '(?<=project\(PGROUTING VERSION )[^;]+' CMakeLists.txt)

# set up your postgres version and port
PGVERSION="12"
PGPORT="5432"
PGBIN="/usr/lib/postgresql/${PGVERSION}/bin"

# Compiler setup

# When more than one compiler is installed
GCC="9"

# Using the default compiler version
unset GCC


ALLDIRS="
bipartite
"

TESTDIRS=${ALLDIRS}
TESTDIRS="bipartite"


function test_compile {

echo ------------------------------------
echo ------------------------------------
echo "Compiling with G++-$1"
echo ------------------------------------

if [ ! -z "$1" ]; then
    update-alternatives --set gcc /usr/bin/gcc-$1
fi


cd build/

# Using all defaults
#cmake ..

# Options Release RelWithDebInfo MinSizeRel Debug
#cmake  -DCMAKE_BUILD_TYPE=Debug ..

# Additional debug information
#cmake -DPgRouting_DEBUG=ON -DCMAKE_BUILD_TYPE=Debug ..

# with documentation (like the one the website)
#cmake  -DDOC_USE_BOOTSTRAP=ON -DWITH_DOC=ON ..

# with developers documentation
#cmake  -DWITH_DOC=ON -DBUILD_DOXY=ON ..

cmake ..

make -j 4
sudo make install
cd ..


echo
echo --------------------------------------------
echo  Execute documentation queries for a particular directories
echo --------------------------------------------


for d in ${TESTDIRS}
do
    #tools/testers/doc_queries_generator.pl  -alg ${d} -documentation  -pgport ${PGPORT}
    tools/testers/doc_queries_generator.pl  -alg ${d} -pgport ${PGPORT}
    
done


#-----------------------------Making doc---------------------------

tools/testers/doc_queries_generator.pl  -alg ${d} -documentation  -pgport ${PGPORT}

tools/testers/doc_queries_generator.pl -alg ${d} -pgport $PGPORT

cd build
#rm -rf doc/*
make doc
#rm -rf doxygen/*
make doxy
cd ..


}

# Uncomment what you need
for compiler in GCC
do
    if [ ! -z "$1" ]; then
        echo "Fresh build"
        rm -rf build/*
    fi
    test_compile ${GCC}
done
