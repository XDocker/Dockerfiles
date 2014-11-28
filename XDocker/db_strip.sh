#!/bin/bash
section_f=$1
the_key=$2
conffile=$3
if [ ! -r "$conffile" ]
   then
     exit 1;
   fi
exec < $conffile
while read section; do
	section=$( echo $section | sed 's/[ \t]*//g' )
	if [ "$section" == "'"$section_f"'=>array(" ] ; then
#    		echo "Section found... $section"
    		IFS='=>'
    		while read key value; do
 			key=$( echo $key | sed 's/[ \t]*//g' )
 
 			if [ "$key" == "'"$the_key"'" ]; then
 #				echo "Key found... $key" 
				value=$( echo $value | sed "s/[',]*//g" )

        			echo $value | sed 's/[ \t]*//g'
        			exit
      			fi
    		done
		exit
  	fi
done
