#!/bin/dash
echo "----------------------------"
echo "mygit-status"
echo "----------------------------"

# Helper function to filter output for test comparisons
filter_output() {
    # Only lines containing test files
    grep -E '^(testfile|file[1-4]|b|mygit-|test[0-9]*\.sh|test\.py) - '
}

echo "----------------------------"
echo "Test 1: No .mygit repository"
echo "----------------------------"
rm -rf .mygit
user_output=$(python3 mygit-status 2>&1)
correct_output="mygit-status: error: no .mygit directory found"
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
echo "Test 2: Empty repository (no commits)"
echo "----------------------------"
rm -rf .mygit
mkdir -p .mygit
echo "0" > .mygit/commit_count
user_output=$(python3 mygit-status 2>&1 | filter_output)
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
echo "Test 3: Untracked file"
echo "----------------------------"
echo "testfile" > testfile
user_output=$(python3 mygit-status 2>&1 | grep 'testfile - ')
correct_output="testfile - untracked"
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
rm testfile

echo "----------------------------"
echo "Test 4: File same as repo"
echo "----------------------------"
mkdir -p .mygit/commits/0
mkdir -p .mygit/index
echo "1" > .mygit/commit_count
echo "testfile" > testfile
cp testfile .mygit/commits/0/
cp testfile .mygit/index/
user_output=$(python3 mygit-status 2>&1 | grep 'testfile - ')
correct_output="testfile - same as repo"
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
rm testfile
rm -rf .mygit/commits/0/testfile
rm -rf .mygit/index/testfile

echo "----------------------------"
echo "Test 5: File changed, changes staged for commit"
echo "----------------------------"
mkdir -p .mygit/commits/0
mkdir -p .mygit/index
echo "testfile" > testfile
echo "oldcontent" > .mygit/commits/0/testfile
echo "newcontent" > .mygit/index/testfile
echo "newcontent" > testfile
user_output=$(python3 mygit-status 2>&1 | grep 'testfile - ')
correct_output="testfile - file changed, changes staged for commit"
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
rm testfile
rm -rf .mygit/commits/0/testfile
rm -rf .mygit/index/testfile

echo "----------------------------"
echo "Test 6: File changed, changes not staged for commit"
echo "----------------------------"
mkdir -p .mygit/commits/0
mkdir -p .mygit/index
echo "testfile" > testfile
echo "oldcontent" > .mygit/commits/0/testfile
echo "oldcontent" > .mygit/index/testfile
echo "newcontent" > testfile
user_output=$(python3 mygit-status 2>&1 | grep 'testfile - ')
correct_output="testfile - file changed, changes not staged for commit"
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
rm testfile
rm -rf .mygit/commits/0/testfile
rm -rf .mygit/index/testfile

echo "----------------------------"
echo "Test 7: File deleted from working directory"
echo "----------------------------"
mkdir -p .mygit/commits/0
mkdir -p .mygit/index
echo "oldcontent" > .mygit/commits/0/testfile
echo "oldcontent" > .mygit/index/testfile
user_output=$(python3 mygit-status 2>&1 | grep 'testfile - ')
correct_output="testfile - file deleted"
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
rm -rf .mygit/commits/0/testfile
rm -rf .mygit/index/testfile

echo "----------------------------"
echo "Test 8: Added to index"
echo "----------------------------"
mkdir -p .mygit/index
echo "testfile" > testfile
cp testfile .mygit/index/
user_output=$(python3 mygit-status 2>&1 | grep 'testfile - ')
correct_output="testfile - added to index"
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
rm testfile
rm -rf .mygit/index/testfile

echo "----------------------------"
echo "Test 9: Multiple files with different statuses"
echo "----------------------------"
mkdir -p .mygit/commits/0
mkdir -p .mygit/index
echo "1" > .mygit/commit_count

# File1: same as repo
echo "file1" > file1
cp file1 .mygit/commits/0/
cp file1 .mygit/index/

# File2: changed but not staged
echo "file2" > file2
echo "old" > .mygit/commits/0/file2
echo "old" > .mygit/index/file2
echo "new" > file2

# File3: untracked
echo "file3" > file3

# File4: deleted
echo "old" > .mygit/commits/0/file4
echo "old" > .mygit/index/file4

user_output=$(python3 mygit-status 2>&1 | grep -E '^(file[1-4]|testfile) - ')
correct_output="file1 - same as repo
file2 - file changed, changes not staged for commit
file3 - untracked
file4 - file deleted"

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

# Cleanup
rm file1 file2 file3
rm -rf .mygit/commits/0/*
rm -rf .mygit/index/*

echo "----------------------------"
echo "All tests completed"
echo "----------------------------"