#!/usr/bin/bash

clear;
PS3="Choose: ";
select choice in "Create Database" "Show Databases" "Connect to a Database" "Exit"
do
 case $choice in
 "Create Database")
  ;;
 "Show Databases")
 ;;
 "Connect to a Database")
 ;;
 "Exit")
 break;
 ;;
 esac
done