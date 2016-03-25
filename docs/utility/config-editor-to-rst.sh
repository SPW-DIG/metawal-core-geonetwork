#!/bin/bash

GNLIB=../../web/target/geonetwork/WEB-INF/lib/

function showUsage
{
  echo -e "\nThis script is used to create a RST file for standards documentation"
  echo
  echo -e "Usage: ./`basename $0`"
}

if [ "$1" = "-h" ]
then
        showUsage
        exit
fi

declare -A l
l[en]="eng"
l[fr]="fre"



# Loop on documentation language
for lang in en fr
do
  mkdir -p ../manuals/$lang/standards/img

  # Loop on standards
  #for s in dublin-core iso19139 iso19110 iso19115-3
  for s in iso19139 iso19115-3
  do
    echo "## Processing $s in $lang ..."
    mkdir -p ../../schemas/$s/doc/$lang/img
    # Generate doc in schema folder
    java -classpath $GNLIB/saxon-9.1.0.8b-patch.jar net.sf.saxon.Transform \
        -s:../../schemas/$s/src/main/plugin/$s/schema-ident.xml \
        -xsl:config-editor-to-rst.xsl \
        -o:../../schemas/$s/doc/$lang/$s.rst \
        lang=${l[$lang]} \
        iso2lang=$lang \
        schema=$s
    # Copy doc in manual folder
    cp -fr ../../schemas/$s/doc/$lang/* ../manuals/$lang/standards/.
  done;
done;