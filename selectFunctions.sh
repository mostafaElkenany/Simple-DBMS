#!/usr/bin/bash


function selectRow {
      printf "\n";
      read -p "Select table:  " table;
      printf "\n";
      if [ -f $table ] 2>/dev/null
      then
        #check if table is empty
        if [ -z "$(cat $table)" ]
        then
          echo "table is empty";
          printf "\n";
        else
          read -p "Enter row number you want to retrieve:  " num;
          printf "\n";
          while ! [[ $num =~ ^[1-9]*$ ]] || [ -z $num ]
          do
            echo "Please enter a valid number greater than 0";
            read -p "Enter row number you want to retrieve:  " num;
            printf "\n";
          done 
          #check if row exists
          if [ -z "$(sed -n "${num}p" $table)" ]
          then
            echo " Sorry, Row does not exist!!";
            printf "\n";
          else  
            sed -n "${num}p" $table | column -t -s "," 2>/dev/null;
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
     read -p "Select table:  " availableTable;
     printf "\n";
     if [ -f $availableTable ] 2>/dev/null
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
}
