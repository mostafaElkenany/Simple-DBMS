#!/usr/bin/bash

# shopt -s extglob;

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

insert