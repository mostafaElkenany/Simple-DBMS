#!/usr/bin/bash
. tableMenu.sh 

 echo "myDB DBMS is running";   
 mkdir -p ~/myDB/Databases ;
 cd ~/myDB/Databases ; 


 clear;
 while true
 do
 PS3="Choose option: ";
 select choice in "Create Database" "Show Databases" "Connect to a Database" "Drop Database" "Exit"
 do
  case $choice in
   "Create Database")
    clear ;
    echo "Enter database name:"
    read db;
    if [ -d $db ]
    then
     echo "Database with the same name already exists!!"
    else
    mkdir $db;
    echo "Database created successfully"
    fi
    break;
    ;;
   "Show Databases")
   clear ;
   ls;
   break;
   ;;
   "Connect to a Database")
   clear ;
   echo "Available databases: " ;
   ls;
   read -p "Select Database you want to connect to: " db;
   if [ -d $db ]
   then
    cd $db;
    echo "Now connected to Database $db";
    tableOptions;
   else
    echo "Database $db not found!!";
   fi 
   break;
   ;;


   "Drop Database")
   clear ;
   ls;
   read -p "Select Database you want to delete: " db;
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
    cd ~ ;
    break 2;
    ;;
  esac
 done
 done