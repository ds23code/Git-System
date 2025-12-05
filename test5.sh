#!/bin/dash
echo "----------------------------"
echo "mygit-rm"
echo "----------------------------"

# Helper function to create test repo structure
setup_repo() {
    rm -rf .mygit
    mkdir -p .mygit/commits/0
    mkdir -p .mygit/index
    echo "1" > .mygit/commit_count
}

echo "----------------------------"
echo "Test 1: No .mygit repository"
echo "----------------------------"
rm -rf .mygit
user_output=$(python3 mygit-rm file.txt 2>&1)
correct_output="mygit-rm: error: no .mygit directory found"
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
setup_repo
user_output=$(python3 mygit-rm 2>&1)
correct_output="usage: mygit-rm [--force] [--cached] <filenames>"
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
echo "Test 3: File not in repository"
echo "----------------------------"
setup_repo
user_output=$(python3 mygit-rm nonexistent.txt 2>&1)
correct_output="mygit-rm: error: 'nonexistent.txt' is not in the mygit repository"
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
echo "Test 4: Basic removal from index and working directory"
echo "----------------------------"
setup_repo
echo "content" > testfile.txt
cp testfile.txt .mygit/index/
cp testfile.txt .mygit/commits/0/
python3 mygit-rm testfile.txt
if [ ! -f ".mygit/index/testfile.txt" ] && [ ! -f "testfile.txt" ]
then
    echo "Removal check: PASS"
else
    echo "Removal check: FAIL"
fi

echo "----------------------------"
echo "Test 5: --cached (remove from index only)"
echo "----------------------------"
setup_repo
echo "content" > testfile.txt
cp testfile.txt .mygit/index/
cp testfile.txt .mygit/commits/0/
python3 mygit-rm --cached testfile.txt
if [ ! -f ".mygit/index/testfile.txt" ] && [ -f "testfile.txt" ]
then
    echo "Removal check: PASS"
else
    echo "Removal check: FAIL"
fi

python3 mygit-rm --force testfile.txt
if [ ! -f ".mygit/index/testfile.txt" ] && [ ! -f "testfile.txt" ]
then
    echo "Force removal check: PASS"
else
    echo "Force removal check: FAIL"
fi

echo "----------------------------"
echo "Test 6: New staged file removal"
echo "----------------------------"
setup_repo
echo "new content" > .mygit/index/newfile.txt
user_output=$(python3 mygit-rm newfile.txt 2>&1)
correct_output="mygit-rm: error: 'newfile.txt' has staged changes in the index"
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

python3 mygit-rm --force newfile.txt
if [ ! -f ".mygit/index/newfile.txt" ]
then
    echo "Force removal check: PASS"
else
    echo "Force removal check: FAIL"
fi

echo "----------------------------"
echo "Test 7: Multiple files"
echo "----------------------------"
setup_repo
echo "f1" > file1.txt
echo "f2" > file2.txt
cp file1.txt .mygit/index/
cp file2.txt .mygit/index/
cp file1.txt .mygit/commits/0/
cp file2.txt .mygit/commits/0/
python3 mygit-rm file1.txt file2.txt
if [ ! -f ".mygit/index/file1.txt" ] && [ ! -f "file1.txt" ] && \
   [ ! -f ".mygit/index/file2.txt" ] && [ ! -f "file2.txt" ]
then
    echo "Removal check: PASS"
else
    echo "Removal check: FAIL"
fi

echo "----------------------------"
echo "Test 8: Mixed success/failure"
echo "----------------------------"
setup_repo
echo "valid" > valid.txt
echo "invalid" > invalid.txt
cp valid.txt .mygit/index/
cp valid.txt .mygit/commits/0/
user_output=$(python3 mygit-rm valid.txt invalid.txt 2>&1)
correct_output="mygit-rm: error: 'invalid.txt' is not in the mygit repository"
if [ "$user_output" = "$correct_output" ] && \
   [ ! -f ".mygit/index/valid.txt" ] && [ ! -f "valid.txt" ] && \
   [ -f "invalid.txt" ]
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
rm -f *.txt
rm -rf dir