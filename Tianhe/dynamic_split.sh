#!/bin/sh
# this.sh <SCRIPT> <FILE> <SPLITN>

# we have less than 0 arguments. Print the help text:

if [ $# -lt 1 ] ;then

echo "======================================================="
    echo "Submit your SCRIPT parralel with limited number "
    echo "USAGE: dynamic_split.sh <SCRIPT> <FILE> <SPLITN>"
    echo "SCRIPT: your SCRIPT "
    echo "FILE: a file contains your list of files or parameters  "
    echo "SPLITN: A numeric that you want to split lines "
    echo "AUTHOR: Qi Zhao<zhaoqi@sysucc.org.cn>"
echo "======================================================="
    exit 0

fi



SCRIPT=$1
FILE=$2
SPLITN=$3

touch temp.sh

cat $FILE | xargs -iF -P1 echo -e "#!/bin/sh \n sh $SCRIPT F" >> temp.sh

SPLITN=$[SPLITN*2]

split -l $SPLITN temp.sh tempH  

ls tempH* | xargs -iF -P2 sh -c "yhbatch -N 1 -p free F" 

rm temp.sh
