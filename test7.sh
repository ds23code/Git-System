#!/bin/dash
echo "----------------------------"
echo "mygit-branch"
echo "----------------------------"

echo "----------------------------"
echo "Test 1: No .mygit directory"
echo "----------------------------"
rm -rf .mygit
user_output=$(./mygit-branch 2>&1)
correct_output="mygit-branch: error: no .mygit directory found"
if [ "$user_output" = "$correct_output" ]
then
    echo "Output check: PASS"
else
    echo "Output check: FAIL"
    echo "Your output:"
    echo "$user_output"
    echo "Correct output:"
    echo "$correct_output"
fi

echo "----------------------------"
echo "Test 2: No commits (commit_count is 0)"
echo "----------------------------"
rm -rf .mygit
mkdir -p .mygit
echo "0" > .mygit/commit_count
user_output=$(./mygit-branch 2>&1)
correct_output="mygit-branch: error: this command can not be run until after the first commit"
if [ "$user_output" = "$correct_output" ]
then
    echo "Output check: PASS"
else
    echo "Output check: FAIL"
    echo "Your output:"
    echo "$user_output"
    echo "Correct output:"
    echo "$correct_output"
fi

echo "----------------------------"
echo "Test 3: List branches with only trunk (no branches directory)"
echo "----------------------------"
rm -rf .mygit
mkdir -p .mygit
echo "1" > .mygit/commit_count
echo "trunk" > .mygit/current_branch
user_output=$(./mygit-branch 2>&1)
correct_output=""
if [ "$user_output" = "$correct_output" ]
then
    echo "Output check: PASS"
else
    echo "Output check: FAIL"
    echo "Your output:"
    echo "$user_output"
    echo "Correct output:"
    echo "$correct_output"
fi

echo "----------------------------"
echo "Test 4: List branches with multiple branches"
echo "----------------------------"
rm -rf .mygit
mkdir -p .mygit/branches
echo "1" > .mygit/commit_count
echo "trunk" > .mygit/current_branch
echo "feature1" > .mygit/branches/feature1
echo "bugfix" > .mygit/branches/bugfix
user_output=$(./mygit-branch 2>&1)
correct_output="bugfix
feature1"
if [ "$user_output" = "$correct_output" ]
then
    echo "Output check: PASS"
else
    echo "Output check: FAIL"
    echo "Your output:"
    echo "$user_output"
    echo "Correct output:"
    echo "$correct_output"
fi

echo "----------------------------"
echo "Test 5: Create branch that already exists"
echo "----------------------------"
rm -rf .mygit
mkdir -p .mygit/branches
echo "1" > .mygit/commit_count
echo "trunk" > .mygit/current_branch
echo "existing_branch" > .mygit/branches/existing_branch
user_output=$(./mygit-branch 2>&1)
correct_output="existing_branch"
if [ "$user_output" = "$correct_output" ]
then
    echo "Output check: PASS"
else
    echo "Output check: FAIL"
    echo "Your output:"
    echo "$user_output"
    echo "Correct output:"
    echo "$correct_output"
fi

echo "----------------------------"
echo "All tests completed"
echo "----------------------------"