#!/bin/dash
echo "----------------------------"
echo "mygit-show"
echo "----------------------------"

echo "----------------------------"
echo "Test 1: No .mygit repository"
echo "----------------------------"
rm -rf .mygit
user_output=$(python3 mygit-show "0:file.txt" 2>&1)
correct_output="mygit-show: error: no .mygit directory found"
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
echo "Test 2: Too few arguments"
echo "----------------------------"
mkdir -p .mygit
user_output=$(python3 mygit-show 2>&1)
correct_output="usage: mygit-show <commit>:<filename>"
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
echo "Test 3: Too many arguments"
echo "----------------------------"
user_output=$(python3 mygit-show "0:file.txt" extra_arg 2>&1)
correct_output="usage: mygit-show <commit>:<filename>"
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
echo "Test 4: Invalid format (missing colon)"
echo "----------------------------"
user_output=$(python3 mygit-show "0file.txt" 2>&1)
correct_output="mygit-show: error: invalid object name '0file.txt'"
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
echo "Test 5: Invalid commit number (negative)"
echo "----------------------------"
user_output=$(python3 mygit-show "-1:file.txt" 2>&1)
correct_output="mygit-show: error: unknown commit '-1'"
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
echo "Test 6: Invalid commit number (non-numeric)"
echo "----------------------------"
user_output=$(python3 mygit-show "abc:file.txt" 2>&1)
correct_output="mygit-show: error: unknown commit 'abc'"
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
echo "Test 7: Unknown commit"
echo "----------------------------"
user_output=$(python3 mygit-show "999:file.txt" 2>&1)
correct_output="mygit-show: error: unknown commit '999'"
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
echo "Test 8: File not found in commit"
echo "----------------------------"
mkdir -p .mygit/commits/0
echo "content" > .mygit/commits/0/existing.txt
user_output=$(python3 mygit-show "0:missing.txt" 2>&1)
correct_output="mygit-show: error: 'missing.txt' not found in commit 0"
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
echo "Test 9: File not found in index"
echo "----------------------------"
mkdir -p .mygit/index
echo "content" > .mygit/index/existing.txt
user_output=$(python3 mygit-show ":missing.txt" 2>&1)
correct_output="mygit-show: error: 'missing.txt' not found in index"
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
echo "Test 10: Show from commit (with trailing newline)"
echo "----------------------------"
mkdir -p .mygit/commits/0
printf "file content\n" > .mygit/commits/0/testfile.txt
user_output=$(python3 mygit-show "0:testfile.txt")
correct_output="file content"
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
echo "Test 11: Show from commit (without trailing newline)"
echo "----------------------------"
printf "file content" > .mygit/commits/0/testfile.txt
user_output=$(python3 mygit-show "0:testfile.txt")
correct_output="file content"
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
echo "Test 12: Show from index"
echo "----------------------------"
mkdir -p .mygit/index
printf "index content\n" > .mygit/index/indexfile.txt
user_output=$(python3 mygit-show ":indexfile.txt")
correct_output="index content"
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

# Cleanup
rm -rf .mygit