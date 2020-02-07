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

function createTable {
read -p "Enter the name of the table: " tableName;
printf "\n";
if [[ ! $tableName  =~ ^[a-zA-Z_]+[a-zA-Z]+[0-9a-zA-Z_]*$ ]]; 
then
echo " Sorry, Invalid format!!";
printf "\n";
else
    if [ -f $tableName ]
     then
      echo " Table already exist!!";
      printf "\n";
    else
      touch .$tableName.metadata;
	    touch $tableName;
      if [ $? -eq 0 ] 
	  then
       read -p "Enter the number of column: " colNumber;
       printf "\n";
       #check if colNumber is integer
       while ! [[ $colNumber =~ ^[1-9]*$ ]];
       do
         echo "Please enter a valid number greater than 0 ";
         read -p "Enter the number of column: " colNumber;
       done
       for (( i = 1; i <= colNumber ; i++ )); 
	     do
         read -p "Enter name for column number [$i]: " colName;
         while ! [ -z "$(grep -w $colName .$tableName.metadata)" ]
         do
          echo "column with the same name already exists, choose another name";
          printf "\n";
          read -p "Enter name for column number [$i]: " colName;
          printf "\n";
         done
         echo "Choose Column $colName data type: ";
         printf "\n";
         select colType in "Integer" "String"
         do
          case $colType in
      	   "Integer")
	          echo -e "$colName:Integer" >> .$tableName.metadata;
      	      break;
      	    ;;
      	   "String")
	          echo -e "$colName:String" >> .$tableName.metadata;
      	      break;
      	    ;;
      	   *)
	          echo "You Must Choose a DataType for this column";
            printf "\n";
            ;;
      	  esac
      	 done
        done
         printf "\n";
         echo "     ***************Table Created Successfully***************";
         printf "\n";
      else
        echo " Error while creating the table!!";
        printf "\n";
      fi
    fi
    fi
}

function insert {
    row="";
    for col in `awk '{print $1}' .$tableName.metadata`
    do
        columnName=$(echo $col|cut -d ':' -f 1) ;
        columnType=$(echo $col|cut -d ':' -f 2);
        read -p "Enter $columnName value: " val;

        #validation for string datatype
        if test $columnType = "String"
        then
            while [ -z $val ] || [[ $val =~ [\,\;\:\-] ]] || [ "$val" -eq "$val" ] 2>/dev/null ;
            do
              echo " Invalid input!, empty value or special characters are not allowed";
              printf "\n";
              read -p "Enter the value of $columnName column: " val;
            done
        fi

        #validation for integer datatype
        if test $columnType = "Integer"
        then
            while ! [ "$val" -eq "$val" ] 2>/dev/null;
            do
              echo " Invalid input!, $columnName column datatype is integer";
              printf "\n";
              read -p "Enter $columnName value: " val;
            done
        fi

        #appending row to table with "," as delimeter
        if test -z $row
        then
            row=$val
        else
            row=$row","$val;
        fi
    done
    echo "$row" >> $tableName;
 printf "\n";
              echo "     ***************Values inserted successfully***************";
              printf "\n";
    break;
}

function selectRow {

      list;
      printf "\n";
      read -p "Select table:  " table;
      printf "\n";
      if [ -f $table ]
      then
        #check if table is empty
        if [ -z "$(cat $table)" ]
        then
          echo "table is empty";
          printf "\n";
        else
          read -p "Enter row number you want to retrieve:  " num;
          printf "\n";
          #check if row exists
          if [ -z "$(sed -n "${num}p" $table)" ]
          then
            echo " Sorry, Row does not exist!!";
            printf "\n";
          else  
            sed -n "${num}p" $table | column -t -s ",";
            printf "\n";
            echo "     ***************retrieved 1 row successfully***************"
            printf "\n";
          fi  
        fi
      else
          echo " Sorry, Table not found!!";  
          printf "\n";
      fi
}

function selectAll {
if [ -f $tableName ]
    then
     list;
     printf "\n";
     read -p "Select table:  " availableTable;
     printf "\n";
     if [ -f $availableTable ]
     then
     #check if table is empty
    if [ -z "$(cat $availableTable)" ]
    then
    echo " Sorry, table is empty!!";
    printf "\n";
    else
     awk 'BEGIN {print "ID"} {print $0}' .$availableTable.metadata | cut -d ':' -f 1 | tr '\n' ',' > .$availableTable.tmp ;
     echo "" >> .$availableTable.tmp;
     awk '{print NR","$0}' $availableTable >> .$availableTable.tmp;
     column -t -s "," .$availableTable.tmp;
     printf "\n";
     echo "     ***************retrieved 1 table successfully***************";
     printf "\n";
     fi
     else
     echo " Sorry, Table doesn't exist!!";
     printf "\n";
     fi
    else
    echo " Sorry, table not found!!";
    printf "\n";
     fi
}

function deleteRow {

        read -p "Select table:  " table;
        printf "\n";
      if [ -f $table ]
      then
        #check if table is empty
        if [ -z "$(cat $table)" ]
        then
          echo " Sorry, table is empty!!";
          printf "\n"
        else
          read -p "Enter row number you want to delete:  " num;
          printf "\n";
          #check if row exists
          if [ -z "$(sed -n "${num}p" $table)" ]
          then
            echo " Sorry, Row does not exist!!";
            printf "\n";
          else  
            sed -i "${num}d" $table;
            echo "     ***************Row $num deleted successfully***************";
            printf "\n";
          fi  
        fi
      else
          echo " Sorry, Table not found!!"; 
          printf "\n"; 
      fi

}

function dropTable {
read -p "Select table you want to delete: " table;
printf "\n";
      if [ -f $table ]
      then
      rm  $table;
      rm  .$table.metadata;
      echo "     ***************Table $table deleted successfully***************"; 
      printf "\n";
      else
      echo " Sorry, Table $table not found!!";
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
  	if [ -f $tableName ]
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
