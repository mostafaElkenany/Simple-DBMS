#!/usr/bin/bash

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
            while [ -z $val ] 2>/dev/null || [[ $val =~ [\,\;\:\-\/\\] ]] || [ "$val" -eq "$val" ] 2>/dev/null
            do
              echo " Invalid input!, empty value or special characters are not allowed";
              printf "\n";
              read -p "Enter the value of $columnName column: " val;
            done
        fi

        #validation for integer datatype
        if test $columnType = "Integer"
        then
            while ! [ "$val" -eq "$val" ] 2>/dev/null
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
