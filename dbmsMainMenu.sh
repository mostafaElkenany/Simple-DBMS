#!/usr/bin/bash
shopt -s extglob;

. tableMenu.sh 

 echo "myDB DBMS is running";   
 mkdir -p ~/myDB/Databases ;
 cd ~/myDB/Databases ; 


 clear;
 while true
 do
 printf "\n";
 PS3="Choose option: ";
 select choice in "Create Database" "Show Databases" "Connect to a Database" "Drop Database" "Exit"
 do
  case $choice in
   "Create Database")
    clear ;
    read -p "Enter database name:" db;
    printf "\n";
    if [[ ! $db  =~ ^[a-zA-Z_]+[a-zA-Z]+[0-9a-zA-Z_]*$ ]]; 
    then
    echo " Sorry, Invalid format!!";
    printf "\n";
    else
    if [ -d $db ]
    then
     echo " Database already exist!!";
     printf "\n";
    else
    mkdir $db;
    echo "     ***************Database created successfully***************";
    printf "\n";
    fi
    fi
    break;
    ;;
   "Show Databases")
   clear ;
   echo "     ***************Available database(s)***************" ;
   printf "\n";
   ls;
   printf "\n";
   break;
   ;;
   "Connect to a Database")
   clear ;
   echo "     ***************Available database(s)***************" ;
   printf "\n";
   ls;
   printf "\n";
   read -p "Select Database you want to connect to: " db;
   printf "\n";
   if [ -d $db ]
   then
    cd $db;
    echo "     ***************Now connected to Database $db***************";
    printf "\n";
    tableOptions;
   else
    echo " Sorry, Database $db not found!!";
    printf "\n"
   fi 
   break;
   ;;


   "Drop Database")
   clear ;
   echo "     ***************Available database(s)***************" ;
   printf "\n"
   ls;
   printf "\n"
   read -p "Select Database you want to delete: " db;
   printf "\n"
   if [ -d $db ]
   then
    rm -r $db;
    echo "     ***************Database $db deleted successfully***************"; 
    printf "\n"
   else
    echo " Sorry, Database $db not found!!";
    printf "\n"
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