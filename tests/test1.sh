#!/bin/dash
echo "----------------------------"
echo "mygit-add"
echo "----------------------------"

echo "----------------------------"
echo "Test 1: No .mygit repository"
echo "----------------------------"
rm -rf .mygit
user_output=$(python3 mygit-add file1.txt 2>&1)
correct_output="mygit-add: error: mygit repository directory .mygit not found"
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
echo "Test 2: No arguments"
echo "----------------------------"
mkdir -p .mygit/index
echo "0" > .mygit/commit_count
user_output=$(python3 mygit-add 2>&1)
correct_output="usage: mygit-add <filenames>"
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
echo "Test 3: Add existing file"
echo "----------------------------"
rm -rf .mygit
mkdir -p .mygit/index
echo "0" > .mygit/commit_count
echo "test content" > test_file.txt
user_output=$(python3 mygit-add test_file.txt 2>&1)
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
if [ -f ".mygit/index/test_file.txt" ]
then
    echo "File staged: PASS"
else
    echo "File staged: FAIL"
fi
if [ "$(cat .mygit/index/test_file.txt)" = "test content" ]
then
    echo "Content check: PASS"
else
    echo "Content check: FAIL"
fi
rm -f test_file.txt

echo "----------------------------"
echo "Test 4: Add multiple existing files"
echo "----------------------------"
rm -rf .mygit
mkdir -p .mygit/index
echo "0" > .mygit/commit_count
echo "file1 content" > file1.txt
echo "file2 content" > file2.txt
user_output=$(python3 mygit-add file1.txt file2.txt 2>&1)
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
if [ -f ".mygit/index/file1.txt" ] && [ -f ".mygit/index/file2.txt" ]
then
    echo "Files staged: PASS"
else
    echo "Files staged: FAIL"
fi
rm -f file1.txt file2.txt

echo "----------------------------"
echo "Test 5: Add file with subdirectory"
echo "----------------------------"
rm -rf .mygit
mkdir -p .mygit/index
echo "0" > .mygit/commit_count
mkdir -p subdir
echo "nested content" > subdir/nested_file.txt
user_output=$(python3 mygit-add subdir/nested_file.txt 2>&1)
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
if [ -f ".mygit/index/subdir/nested_file.txt" ]
then
    echo "Nested file staged: PASS"
else
    echo "Nested file staged: FAIL"
fi
rm -rf subdir

echo "----------------------------"
echo "Test 6: Try to add directory"
echo "----------------------------"
rm -rf .mygit
mkdir -p .mygit/index
echo "0" > .mygit/commit_count
mkdir test_dir
user_output=$(python3 mygit-add test_dir 2>&1)
correct_output="mygit-add: error: can not open 'test_dir'"
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
rmdir test_dir

echo "----------------------------"
echo "Test 7: Add non-existent file (never tracked)"
echo "----------------------------"
rm -rf .mygit
mkdir -p .mygit/index
echo "0" > .mygit/commit_count
user_output=$(python3 mygit-add nonexistent.txt 2>&1)
correct_output="mygit-add: error: can not open 'nonexistent.txt'"
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
echo "Test 8: Remove previously tracked file"
echo "----------------------------"
rm -rf .mygit
mkdir -p .mygit/index
mkdir -p .mygit/commits/0
echo "1" > .mygit/commit_count
echo "old content" > .mygit/commits/0/tracked_file.txt
echo "staged content" > .mygit/index/tracked_file.txt
user_output=$(python3 mygit-add tracked_file.txt 2>&1)
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
if [ ! -f ".mygit/index/tracked_file.txt" ]
then
    echo "File removal staged: PASS"
else
    echo "File removal staged: FAIL"
fi

echo "----------------------------"
echo "Test 9: Remove file not in index but in last commit"
echo "----------------------------"
rm -rf .mygit
mkdir -p .mygit/index
mkdir -p .mygit/commits/0
echo "1" > .mygit/commit_count
echo "committed content" > .mygit/commits/0/another_file.txt
user_output=$(python3 mygit-add another_file.txt 2>&1)
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
echo "Test 10: Non-existent file with no commits"
echo "----------------------------"
rm -rf .mygit
mkdir -p .mygit/index
# No commit_count file (equivalent to 0 commits)
user_output=$(python3 mygit-add missing.txt 2>&1)
correct_output="mygit-add: error: can not open 'missing.txt'"
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
echo "Test 11: Mixed existing and non-existent files"
echo "----------------------------"
rm -rf .mygit
mkdir -p .mygit/index
echo "0" > .mygit/commit_count
echo "exists" > existing.txt
user_output=$(python3 mygit-add existing.txt nonexistent.txt 2>&1)
correct_output="mygit-add: error: can not open 'nonexistent.txt'"
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
# Script should exit on first error, so existing.txt should not be staged
if [ ! -f ".mygit/index/existing.txt" ]
then
    echo "Early exit check: PASS"
else
    echo "Early exit check: FAIL"
fi
rm -f existing.txt

echo "----------------------------"
echo "All tests completed"
echo "----------------------------"