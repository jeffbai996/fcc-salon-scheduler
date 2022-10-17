#!/bin/bash

# pg_dump -cC --inserts -U freecodecamp salon > salon.sql

# psql variable
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi


  AVAILABLE_SERVICES=$($PSQL "SELECT * FROM services")

  echo -e "Welcome to My Salon, how can I help you?\n"
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED
  if [[ $SERVICE_ID_SELECTED > 5 ]]
  then
    MAIN_MENU "Sorry, please input a valid number."
  else
    # get customer info
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    # if no customer name
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nWhat's your name?"
      read CUSTOMER_NAME

      # insert new customer
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    fi
    # get appointment time
    echo -e "\nWhat time would you like your cut,$CUSTOMER_NAME?"
    read SERVICE_TIME


  fi
}

MAIN_MENU