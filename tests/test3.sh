#!/bin/dash
echo "----------------------------"
echo "mygit-log"
echo "----------------------------"

echo "----------------------------"
echo "Test 1: No .mygit repository"
echo "----------------------------"
rm -rf .mygit
user_output=$(python3 mygit-log 2>&1)
correct_output="mygit-log: error: no .mygit directory found"
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
echo "Test 2: Too many arguments"
echo "----------------------------"
mkdir -p .mygit
user_output=$(python3 mygit-log extra_arg 2>&1)
correct_output="usage: mygit-log"
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
echo "Test 3: No commits (no commit_count file)"
echo "----------------------------"
rm -rf .mygit
mkdir -p .mygit/commits
user_output=$(python3 mygit-log 2>&1)
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
echo "Test 4: No commits (commit_count is 0)"
echo "----------------------------"
echo "0" > .mygit/commit_count
user_output=$(python3 mygit-log 2>&1)
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
echo "Test 5: Single commit"
echo "----------------------------"
mkdir -p .mygit/commits/0
echo "1" > .mygit/commit_count
echo '{"message": "Initial commit", "files": ["file1.txt"]}' > .mygit/commits/0/commit_info
user_output=$(python3 mygit-log 2>&1)
correct_output="0 Initial commit"
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
echo "Test 6: Multiple commits (newest first)"
echo "----------------------------"
mkdir -p .mygit/commits/1
mkdir -p .mygit/commits/2
echo "3" > .mygit/commit_count
echo '{"message": "Second commit", "files": ["file2.txt"]}' > .mygit/commits/1/commit_info
echo '{"message": "Third commit", "files": ["file3.txt"]}' > .mygit/commits/2/commit_info
user_output=$(python3 mygit-log 2>&1)
correct_output="2 Third commit
1 Second commit
0 Initial commit"
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
echo "Test 7: Skip malformed commit_info"
echo "----------------------------"
mkdir -p .mygit/commits/3
echo "4" > .mygit/commit_count
echo "invalid json" > .mygit/commits/3/commit_info
user_output=$(python3 mygit-log 2>&1)
correct_output="2 Third commit
1 Second commit
0 Initial commit"
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
echo "Test 8: Skip missing commit_info"
echo "----------------------------"
mkdir -p .mygit/commits/4
echo "5" > .mygit/commit_count
# No commit_info file created
user_output=$(python3 mygit-log 2>&1)
correct_output="2 Third commit
1 Second commit
0 Initial commit"
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
echo "Test 9: Commit with message containing spaces"
echo "----------------------------"
mkdir -p .mygit/commits/5
echo "6" > .mygit/commit_count
echo '{"message": "This is a long commit message with spaces", "files": ["file.txt"]}' > .mygit/commits/5/commit_info
user_output=$(python3 mygit-log | head -1)
correct_output="5 This is a long commit message with spaces"
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