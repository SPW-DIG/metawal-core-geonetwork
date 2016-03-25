#!/bin/bash

GNLIB=../../web/target/geonetwork/WEB-INF/lib/

function showUsage
{
  echo -e "\nThis script is used to create a RST file for schema elements"
  echo
  echo -e "Usage: ./`basename $0 $1 $2` iso19139 eng en"
}

if [ "$1" = "-h" ]
then
        showUsage
        exit
fi


if [ $# -lt 3 ]
then
  showUsage
  exit
fi

mkdir -p ../manuals/$3/annexes/standards/
mkdir -p ../../schemas/$1/doc/$3

# Convert schema configuration to RST in schema folder
java -classpath $GNLIB/saxon-9.1.0.8b-patch.jar net.sf.saxon.Transform \
        -s:build.xml \
        -xsl:schema-loc-to-rst.xsl \
        -o:../../schemas/$1/doc/$3/$1.rst \
        lang=$2 \
        schema=$1

# Copy schema RST and images doc from schema to manuals folder
cp ../../schemas/$1/doc/$3/* ../manuals/$3/annexes/standards/.