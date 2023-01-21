#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Clear worldcup database tables ====================
echo $($PSQL "TRUNCATE TABLE games, teams")

# Loop through the games.scv to add data ============
cat games.csv | while IFS=, read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    if [[ $WINNER_ID == '' ]]
    then
      INSERTED=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERTED == 'INSERT 0 1' ]]
      then 
        echo Inserted $WINNER into teams table
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      fi
    fi
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    if [[ $OPPONENT_ID == '' ]]
    then
      INSERTED=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERTED == 'INSERT 0 1' ]]
      then 
        echo Inserted $OPPONENT into teams table
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
      fi
    fi
    INSERTED=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERTED == 'INSERT 0 1' ]]
    then 
      echo Inserted game entrie
    fi
  fi
done
