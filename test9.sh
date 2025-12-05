#!/bin/dash

echo "----------------------------"
echo "mygit-merge"
echo "----------------------------"

echo "----------------------------"
echo "Test 1: Missing arguments"
echo "----------------------------"
rm -rf .mygit
user_output=$(python3 mygit-merge 2>&1)
correct_output="usage: mygit-merge <branch-name|commit-number> -m <message>"
if [ "$user_output" = "$correct_output" ]; then
  echo "Output check: PASS"
else
  echo "Output check: FAIL"
  echo "Your output:"
  echo "$user_output"
  echo "Correct output:"
  echo "$correct_output"
fi

echo "----------------------------"
echo "Test 2: No .mygit directory"
echo "----------------------------"
user_output=$(python3 mygit-merge trunk -m \"Merge commit\" 2>&1)
correct_output="mygit-merge: error: no .mygit directory found"
if [ "$user_output" = "$correct_output" ]; then
  echo "Output check: PASS"
else
  echo "Output check: FAIL"
  echo "Your output:"
  echo "$user_output"
  echo "Correct output:"
  echo "$correct_output"
fi


rm -rf .mygit
mkdir -p .mygit/branches .mygit/commits .mygit/index

echo "0" > .mygit/commit_count
echo "trunk" > .mygit/current_branch
echo "0" > .mygit/branches/trunk

mkdir -p .mygit/commits/0
echo "Hello world" > .mygit/commits/0/file.txt

echo "----------------------------"
echo "Test 3: Merge non-existent branch"
echo "----------------------------"
user_output=$(python3 mygit-merge no_such_branch -m \"Merge message\" 2>&1)
correct_output="mygit-merge: error: unknown branch 'no_such_branch'"
if [ "$user_output" = "$correct_output" ]; then
  echo "Output check: PASS"
else
  echo "Output check: FAIL"
  echo "Your output:"
  echo "$user_output"
  echo "Correct output:"
  echo "$correct_output"
fi
