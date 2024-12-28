#!/bin/bash


PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# echo "Please provide an element as an argument."

if [[ -z "$1" ]]
then 
    echo "Please provide an element as an argument."
else
    if [[ "$1" =~ ^[0-9]+$ ]]
    then 
        QUERY_CONDITION="elements.atomic_number=$1"
    else
        QUERY_CONDITION="elements.symbol='$1' OR elements.name='$1'"
    fi

    SELECTED_ELEMENT=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type,properties.atomic_mass,properties.melting_point_celsius,
    properties.boiling_point_celsius FROM elements INNER JOIN properties ON elements.atomic_number=properties.atomic_number INNER JOIN types ON 
    properties.type_id=types.type_id WHERE $QUERY_CONDITION;")
    
    if [[ -z "$SELECTED_ELEMENT" ]]
    then
        echo "I could not find that element in the database."
    else
        echo "$SELECTED_ELEMENT" | while read NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELTING_POINT BAR BOILING_POINT
        do 
        echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        done
    fi

    
fi
