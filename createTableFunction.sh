#!/usr/bin/bash


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
          while ! [[ $colNumber =~ ^[1-9]*$ ]] || [ -z $colNumber ]
          do
            echo "Please enter a valid number greater than 0 ";
            read -p "Enter the number of column: " colNumber;
          done
          for (( i = 1; i <= colNumber ; i++ )); 
          do
            read -p "Enter name for column number [$i]: " colName;
            while [[ ! $colName  =~ ^[a-zA-Z_]+[a-zA-Z]+[0-9a-zA-Z_]*$ ]]
            do
              echo "Invalid formate for column name";
              printf "\n";
              read -p "Enter name for column number [$i]: " colName;
              printf "\n";
            done
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
