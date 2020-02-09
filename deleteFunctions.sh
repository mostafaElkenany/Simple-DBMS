#!/usr/bin/bash


function deleteRow {
    read -p "Select table:  " table;
    printf "\n";
    if [ -f $table ] 2>/dev/null
    then
        #check if table is empty
        if [ -z "$(cat $table)" ]
        then
          echo " Sorry, table is empty!!";
          printf "\n"
        else
          read -p "Enter row number you want to delete:  " num;
          printf "\n";
          #validate num
          while ! [[ $num =~ ^[1-9]*$ ]] || [ -z $num ]
          do
            echo "Please enter a valid number greater than 0";
            read -p "Enter row number you want to delete:  " num;
            printf "\n";
          done
          #check if row exists
          if [ -z "$(sed -n "${num}p" $table)" ] 2>/dev/null
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
      if [ -f $table ] 2>/dev/null
      then
      rm  $table;
      rm  .$table.metadata;
      rm  .$table.tmp;
      echo "     ***************Table $table deleted successfully***************"; 
      printf "\n";
      else
      echo " Sorry, Table $table not found!!";
      printf "\n";
      fi 
}
