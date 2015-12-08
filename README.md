# notifox
detects affected tests

## how to run
1. checkout branch with changes
2. run scripts/difter.rb

The script will compare step definitions from the current branch and the master branch,
and will detect any changes in the step definitions. 
Then, it will report the affected cucumber tests associated with those changes.
