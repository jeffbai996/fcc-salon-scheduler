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
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    # if no customer name
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nWhat's your name?"
      read CUSTOMER_NAME

      # insert new customer
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    fi
    # get appointment time
    echo -e "\nWhat time would you like your cut, "$CUSTOMER_NAME"?"
    read SERVICE_TIME

    # insert new appointment
    INSERT_APPT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")

    # get name of selected service
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    echo "I have put you down for a"$SERVICE_NAME" at "$SERVICE_TIME","$CUSTOMER_NAME"."
  fi
}

MAIN_MENU