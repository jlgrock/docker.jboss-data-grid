#!/bin/sh

# Load the version from the VERSION file
for line in $(cat VERSION)
do
  case $line in
    CENTOS=*)  eval $line ;; # beware! eval!
	JDK=*)  eval $line ;; # beware! eval!
    JBOSS_JDG_BASE=*)  eval $line ;; # beware! eval!
	JBOSS_JDG=*)  eval $line ;; # beware! eval!
    *) ;;
   esac
done
