#!/usr/bin/bash

shopt -s extglob;

. createTableFunction.sh
. deleteFunctions.sh
. selectFunctions.sh
. insertFunction.sh
. tableMenu.sh 


function listDB {
 if [ -z "$(ls)" ]
   then
      echo "No databases avilable";
      break;
   else
     echo "     ***************Available database(s)***************" ;
     printf "\n";
     ls;
     printf "\n";
 fi
}
##########################################
function connectToDB {
  read -p "Select Database you want to connect to: " db;
  printf "\n";
  if [ -z $db ] 2>/dev/null
  then
    echo "No input, please enter database name";
  elif [ -d $db ] 2>/dev/null
  then
    cd $db;
    echo "     ***************Now connected to Database $db***************";
    printf "\n";
    tableOptions;
  else
      echo " Sorry, Database $db not found!!";
      printf "\n"
   
  fi
}
###########################################
function drop {
    read -p "Select Database you want to delete: " db;
    printf "\n"
    if [ -z $db ] 2>/dev/null
    then
      echo "No input, please enter database name";
    elif [ -d $db ] 2>/dev/null 
    then
      rm -r $db;
      echo "     ***************Database $db deleted successfully***************"; 
      printf "\n"
    else
        echo " Sorry, Database $db not found!!";
        printf "\n"
    fi
}
###########################################
function createDB {
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
}

###########################################
mkdir -p ~/myDB/Databases ;
cd ~/myDB/Databases ; 
clear;
echo "myDB DBMS is running";   
###########################################
 while true
 do
 printf "\n";
 PS3="Choose option: ";
 select choice in "Create Database" "Show Databases" "Connect to a Database" "Drop Database" "Exit"
 do
  case $choice in
   "Create Database")
      clear ;
      createDB;    
      break;
    ;;

##############################################
   "Show Databases")
     clear ;
     listDB;
     break;
     ;;

##############################################
   "Connect to a Database")
     clear ;
     listDB;
     connectToDB;
     break;
     ;;

##############################################
   "Drop Database")
     clear ;
     listDB;
     drop;     
     break;
     ;; 

##############################################
   "Exit")
      cd ~ ;
      break 2;
      ;;
  esac
 done
 done
