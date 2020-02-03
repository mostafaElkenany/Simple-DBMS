#!/usr/bin/bash
function tableOptions {	
clear;

while [ $? -eq 0 ]
do
 PS3="Select an Option";
 select option in "List Tables" "Create New Table" "Insert Data" "Delete From Table" "Select From Table"
 do

# #create a new table
  case $option in
   "Create New Table")
    echo "Enter the name of the table: ";
    read tableName;
    if [ -f $tableName.data ]
     then
      echo "Table already exist";
    else
      touch $tableName.metadata;
	  touch $tableName.data;
      if [ $? -eq 0 ] 
	  then
       echo "Enter the number of column";
       read colNumber;
    #    echo "The Number Of Columns Is: $colNumber" >> $tableName.metadata;
       for (( i = 1; i <= colNumber ; i++ )); 
	   do
        echo "Enter name for column number [$i]: ";
        read colName;
        PS3="Choose Column $colName data type";
         select colType in "Integer" "String"
         do
          case $colType in
      	   "Integer")
	          echo -e "$colName:Integer" >> $tableName.metadata;
      	      break;
      	    ;;
      	   "String")
	          echo -e "$colName:String" >> $tableName.metadata;
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
	 break;
     ;;

# #List the database tables
"List Tables")
    if [ -z "$(ls)" ]
     then
      echo "There is no tables in this database";
     else
      echo "The tables in this database are: ";
	  ls;
     fi
     break;
     ;;


# #insert data into table
    "Insert Data")
	read -p "Select the table you want to insert into:  " tableName;
	 if [ -f $tableName.data ]
	 then
	    insert;
	 else 
	 	echo "not found";		
	 fi
     ;;

#Delete From Table
    "Delete From Table")
;;

#Select From Table
    "Select From Table")
     echo "Enter table name to select its data"
     read tableSelected
     if [ $tableSelected -eq $tableName] 
	 then
      cat $tableSelected;
     else
      echo "Table doesn't exist";
     fi
	;;
	esac
  done
done
}
#here we must show a list of available columns

        
#create a new database
function createTable{
	echo "enter table name: ";
	read tbName;
	if [ ! -e $dataBaseList/$tbName ] && [ $tbName != "" ]
		then
			touch $dataBaseList/$tbName;
			if [ $? -eq 0]
				then
					echo "enter the number of columns";
					read numOfCol;
					for(( i = 1; i <= numOfCol ; i++ ))
					do
					 echo "enter column name num $z "	
}

#list tables in a selected DB

function listTables{
	i=1;
	for table in $dataBaseList/$tbName
	do
		$tbArr[$i]=$table;
		let $i++;
	done

	if [ $tbArr -eq 0 ]
		then
			echo "Sorry, there is no tables like that to list";
			return ;
	fi
	
	echo "The tables availbale in this database are: ";

	i=1
	for table in `ls $dataBaseList`
	do
		$tbArr[$i]=$table;
		echo $i") "$table;
		let i=i+1;
	done
}

function insert {
    row="";
    for col in `awk '{print $1}' $tableName.metadata`
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
              read -p "Enter $columnName value: " val;
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

        #appending row to table with , as
        if test -z $row
        then
            row=$val
        else
            row=$row","$val;
        fi
    done
    echo "$row" >> $tableName.data;
    break;
}

function deletefromTable{

}

function selectfromTable{

	for table in $dataBaseList/$tbName
	do
		cat $table;	
	done
}

