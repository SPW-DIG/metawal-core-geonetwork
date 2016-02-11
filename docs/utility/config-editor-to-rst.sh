#!/bin/bash

GNLIB=../../web/target/geonetwork/WEB-INF/lib/

function showUsage
{
  echo -e "\nThis script is used to create a RST file for schema elements (based on the config-editor file)"
  echo
  echo -e "Usage: ./`basename $0 $1 $2` iso19115-3 fre fr"
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

java -classpath $GNLIB/saxon-9.1.0.8b-patch.jar net.sf.saxon.Transform \
        -s:../../schemas/$1/src/main/plugin/$1/schema-ident.xml \
        -xsl:config-editor-to-rst.xsl \
        -o:../manuals/$3/annexes/standards/$1.rst \
        lang=$2 \
        schema=$1