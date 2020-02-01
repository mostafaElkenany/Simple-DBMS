#!/usr/bin/bash

 echo "myDB DBMS is running";   
 mkdir -p myDB/Databases ;
 cd myDB/Databases ; 


 clear;
 PS3="Choose option: ";
 while [ 1 -eq 1 ]
 do
 select choice in "Create Database" "Show Databases" "Connect to a Database" "Drop Database" "Exit"
 do
  case $choice in
   "Create Database")
    echo "Enter database name:"
    read dbName;
    if [ -d $dbName ]
    then
     echo "Database with the same name already exists!!"
    else
    mkdir $dbName;
    echo "Database created successfully"
    fi
   break;
    ;;
   "Show Databases")
   ls;
   break;
   ;;
   "Connect to a Database")
   ls;
   echo "Select Database you want to connect to: "
   read db;
   if [ -d $db ]
   then
    cd $db;
    echo "Now connected to Database $db"; 
   else
    echo "Database $db not found!!";
   fi 
   break;
   ;;


   "Drop Database")
   ls;
   echo "Select Database you want to delete: "
   read db;
   if [ -d $db ]
   then
    rm -r $db;
    echo "Database $db deleted successfully"; 
   else
    echo "Database $db not found!!";
   fi 
   break;
   ;; 

   "Exit")
   break 2;
   ;;
  esac
 done
 done