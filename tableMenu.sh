#!/usr/bin/bash

function list {
    if [ -z "$(ls)" ]
    then
      printf "\n";
      echo " There is no tables in this database!!";
      printf "\n";
      break;
    else
      echo "     ***************Available tables***************";
      printf "\n";
      ls | sort -n;
      printf "\n";
    fi  
}

function tableOptions {	
  clear;

  while [ $? -eq 0 ]
  do
  PS3="Select an Option:  ";
  select option in "Create New Table" "List Tables" "Insert Data" "Select Row" "Select all From Table" "Delete Row From Table" "Drop Table" "Back to main menu"
  do
  printf "\n";

  # create a new table
    case $option in
    "Create New Table")
      clear;
      createTable;
      break;
    ;;

  # List The Database Tables
    "List Tables")
      clear; 
      list;
      break;
      ;;


  # Insert Data Into Table
    "Insert Data")
      clear ;
      printf "\n";
      list;
      printf "\n";
      read -p "Select the table you want to insert into:  " tableName;
      printf "\n";
      if [ -z $tableName ] 2>/dev/null
      then
        echo "No input, please enter table name";
      elif [ -f $tableName ]
      then
        insert;
      else 
        echo " Sorry, Table not found!!";
        printf "\n";
        break; 		
      fi
      ;;

  # Select Row From Table
    "Select Row")
      clear;
      list;
      selectRow;
      break;
      ;;

  # Select all From Table
    "Select all From Table")
      clear;
      list;
      selectAll;
      break;
      ;;

  # Delete From Table
      "Delete Row From Table")
        clear;
        list
        deleteRow;
        break; 
        ;;


  # Drop Table
      "Drop Table")
        clear;
        list;
        dropTable;
        break;
        ;;

  # Back To Main Menu
    "Back to main menu")
      cd .. ;
      clear;
      break 2;
      ;; 
    esac
    done
  done
}
