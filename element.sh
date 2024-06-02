#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]; then
  echo -e "Please provide an element as an argument."

else
  if [[ $1 =~ ^[0-9]+$ ]]; then
    QUERY_RESULT=$($PSQL "SELECT properties.atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties JOIN elements USING(atomic_number) JOIN types USING (type_id) WHERE atomic_number = $1;")
  else
    QUERY_RESULT=$($PSQL "SELECT properties.atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties JOIN elements USING(atomic_number) JOIN types USING (type_id) WHERE symbol = '$1' OR name = '$1';")
  fi

  if [[ -z $QUERY_RESULT ]]; then
    echo -e "I could not find that element in the database."
  else
    echo $QUERY_RESULT | while IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOLING_POINT; do
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOLING_POINT celsius."
    done
  fi
fi
