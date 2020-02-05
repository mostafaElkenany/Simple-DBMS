#!/usr/bin/bash

function list {
      if [ -z "$(ls)" ]
     then
      echo "There is no tables in this database";
     else
      echo "The tables in this database are: ";
      ls | sort -u ;
     fi  
}

function createTable {
read -p "Enter the name of the table: " tableName;
if [[ ! $tableName  =~ ^[a-zA-Z_]+[a-zA-Z]+[0-9a-zA-Z_]*$ ]]; 
then
echo "Invalid format, Table name must start with string only!!";
else
    if [ -f $tableName ]
     then
      echo "Table already exist";
    else
      touch .$tableName.metadata;
	  touch $tableName;
      if [ $? -eq 0 ] 
	  then
       read -p "Enter the number of column: " colNumber;
       for (( i = 1; i <= colNumber ; i++ )); 
	     do
        read -p "Enter name for column number [$i]: " colName;

        PS3="Choose Column $colName data type: ";
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
            ;;
      	  esac
      	 done
        done
         echo "Table Created Successfully";
      else
        echo "Error while creating the table";
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
            while [ -z $val ] || [ "$val" -eq "$val" ] 2>/dev/null;
            do
              echo "invalid datatype!, $columnName column datatype is string";
              read -p "Enter the value of $columnName column: " val;
            done
        fi

        #validation for integer datatype
        if test $columnType = "Integer"
        then
            while ! [ "$val" -eq "$val" ] 2>/dev/null;
            do
              echo "invalid datatype!, $columnName column datatype is integer";
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
    break;
}

function selectRow {

      #echo "The available tables in this DB: ";
      list;
      echo "------------------------------------------";
      read -p "Select table:  " table;
      if [ -f $table ]
      then
        #check if table is empty
        if [ -z "$(cat $table)" ]
        then
          echo "table is empty";
        else
          read -p "Enter row number you want to retrieve:  " num;
          #check if row exists
          if [ -z "$(sed -n "${num}p" $table)" ]
          then
            echo "Row does not exist";
          else  
            sed -n "${num}p" $table | column -t -s ",";
          fi  
        fi
      else
          echo "Table not found!!";  
      fi
}

function selectAll {
if [ -f $tableName ]
    then
    echo "The available tables in this DB: ";
     ls;
     echo "------------------------------------------";
     read -p "Enter table name to select: " availableTable;
     if [ -f $availableTable ]
     then
     #check if table is empty
    if [ -z "$(cat $availableTable)" ]
    then
    echo "table is empty";
    else
    echo "retrieved data for 1 table";
     awk '{print $1}' .$availableTable.metadata | cut -d ':' -f 1 | tr '\n' ' ' | column -t;
     awk '{print NR,$0}' $availableTable | column -t -s ",";
     fi
     else
     echo "This table doesn't exist in the DB";
     fi
    else
    echo "There is no table in this DB";
     fi
}

function deleteRow {

        read -p "Select table:  " table;
      if [ -f $table ]
      then
        #check if table is empty
        if [ -z "$(cat $table)" ]
        then
          echo "table is empty";
        else
          read -p "Enter row number you want to delete:  " num;
          #check if row exists
          if [ -z "$(sed -n "${num}p" $table)" ]
          then
            echo "Row does not exist";
          else  
            sed -i "${num}d" $table;
            echo "Row deleted successfully";
          fi  
        fi
      else
          echo "Table not found!!";  
      fi

}

function dropTable {
read -p "Select table you want to delete: " table;
      if [ -f $table ]
      then
      rm  $table;
      rm  .$table.metadata;
      echo "Table $table deleted successfully"; 
      else
      echo "Table $table not found!!";
      fi 
}



function tableOptions {	
clear;

while [ $? -eq 0 ]
do
 PS3="Select an Option:  ";
 select option in "Create New Table" "List Tables" "Insert Data" "Select Row" "Select all From Table" "Delete Row From Table" "Drop Table" "Back to main menu"
 do

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
    list;
	  read -p "Select the table you want to insert into:  " tableName;
  	if [ -f $tableName ]
	  then
	    insert;
	  else 
	 	echo "Table not found";
    break; 		
	  fi
    ;;

# Select Row From Table
   "Select Row")
   clear;
   selectRow;
   break;
   ;;

# Select all From Table
    "Select all From Table")
    clear;
    selectAll;
    break;
    ;;

# Delete From Table
    "Delete Row From Table")
    clear;
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
