#!/bin/bash
HostFile='/etc/hosts'

host_exists () {
	if grep -q "$1" "$HostFile"; then
	    return 1
	else
	    return 0
	fi
}

if host_exists '#valet hosts' -eq 0; then
	echo '#valet hosts' >> $HostFile
	echo '127.0.0.1 valet.test' >> $HostFile
fi

#get valet hosts line
line=$(grep -n "#valet hosts" $HostFile | cut -d: -f1)

for i in $(valet links | cut -d'|' -f2 | sed '1,3 d;$ d')  
do
	if host_exists "$i.test" -eq 0
	then
		sed -ie $((line+1))"s/$/ $i.test&/" $HostFile
		echo "Domain $i.test successfully registered"
	# else
	# 	echo "$i.test is already registered"
	fi
done
