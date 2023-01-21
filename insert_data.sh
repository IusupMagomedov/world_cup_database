#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games, teams")" 

cat games.csv | while IFS=, read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    $($PSQL "
    INSERT INTO 
    teams (name) 
    VALUES ('$WINNER')" )
    $($PSQL "
    INSERT INTO 
    teams (name) 
    VALUES ('$OPPONENT')" )
  fi
done

# echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"
