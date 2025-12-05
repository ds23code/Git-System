#!/bin/dash
echo "----------------------------"
echo "mygit-init"
echo "----------------------------"

echo "----------------------------"
echo "Test 1: First initialization"
echo "----------------------------"
rm -rf .mygit
user_output=$(python3 mygit-init 2>&1)
correct_output="Initialized empty mygit repository in .mygit"
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
if [ -d ".mygit" ]
then
    echo "Directory created: PASS"
else
    echo "Directory created: FAIL"
fi

echo "----------------------------"
echo "Test 2: Check .mygit/index directory"
echo "----------------------------"
if [ -d ".mygit/index" ]
then
    echo "Index directory: PASS"
else
    echo "Index directory: FAIL"
fi

echo "----------------------------"
echo "Test 3: Check .mygit/commits directory"
echo "----------------------------"
if [ -d ".mygit/commits" ]
then
    echo "Commits directory: PASS"
else
    echo "Commits directory: FAIL"
fi

echo "----------------------------"
echo "Test 4: Check .mygit/branches directory"
echo "----------------------------"
if [ -d ".mygit/branches" ]
then
    echo "Branches directory: PASS"
else
    echo "Branches directory: FAIL"
fi

echo "----------------------------"
echo "Test 5: Check commit_count file"
echo "----------------------------"
if [ -f ".mygit/commit_count" ]
then
    echo "Commit count file exists: PASS"
else
    echo "Commit count file exists: FAIL"
fi
if [ "$(cat .mygit/commit_count 2>/dev/null)" = "0" ]
then
    echo "Commit count content: PASS"
else
    echo "Commit count content: FAIL"
    echo "Expected: 0"
    echo "Got: $(cat .mygit/commit_count 2>/dev/null)"
fi

echo "----------------------------"
echo "Test 6: Check current_branch file"
echo "----------------------------"
if [ -f ".mygit/current_branch" ]
then
    echo "Current branch file exists: PASS"
else
    echo "Current branch file exists: FAIL"
fi
if [ "$(cat .mygit/current_branch 2>/dev/null)" = "trunk" ]
then
    echo "Current branch content: PASS"
else
    echo "Current branch content: FAIL"
    echo "Expected: trunk"
    echo "Got: $(cat .mygit/current_branch 2>/dev/null)"
fi

echo "----------------------------"
echo "Test 7: Check trunk branch file"
echo "----------------------------"
if [ -f ".mygit/branches/trunk" ]
then
    echo "Trunk branch file exists: PASS"
else
    echo "Trunk branch file exists: FAIL"
fi
if [ "$(cat .mygit/branches/trunk 2>/dev/null)" = "" ]
then
    echo "Trunk branch content: PASS"
else
    echo "Trunk branch content: FAIL"
    echo "Expected: (empty)"
    echo "Got: $(cat .mygit/branches/trunk 2>/dev/null)"
fi

echo "----------------------------"
echo "Test 8: Repository already exists"
echo "----------------------------"
user_output=$(python3 mygit-init 2>&1)
correct_output="mygit-init: error: .mygit already exists"
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
echo "Test 9: Exit status on existing repository"
echo "----------------------------"
python3 mygit-init >/dev/null 2>&1
exit_status=$?
if [ $exit_status -eq 1 ]
then
    echo "Exit status check: PASS"
else
    echo "Exit status check: FAIL"
    echo "Expected: 1"
    echo "Got: $exit_status"
fi

echo "----------------------------"
echo "Test 10: Files preserved after failed init"
echo "----------------------------"
# Check that original files are still intact after failed initialization
if [ -f ".mygit/commit_count" ] && [ "$(cat .mygit/commit_count)" = "0" ]
then
    echo "Original files preserved: PASS"
else
    echo "Original files preserved: FAIL"
fi

echo "----------------------------"
echo "Test 11: Re-init after manual cleanup"
echo "----------------------------"
rm -rf .mygit
user_output=$(python3 mygit-init 2>&1)
correct_output="Initialized empty mygit repository in .mygit"
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
if [ -d ".mygit" ]
then
    echo "Directory recreated: PASS"
else
    echo "Directory recreated: FAIL"
fi

echo "----------------------------"
echo "Test 12: Complete structure verification"
echo "----------------------------"
structure_valid=true
required_dirs=".mygit .mygit/index .mygit/commits .mygit/branches"
required_files=".mygit/commit_count .mygit/current_branch .mygit/branches/trunk"

for dir in $required_dirs
do
    if [ ! -d "$dir" ]
    then
        echo "Missing directory: $dir"
        structure_valid=false
    fi
done

for file in $required_files
do
    if [ ! -f "$file" ]
    then
        echo "Missing file: $file"
        structure_valid=false
    fi
done

if [ "$structure_valid" = true ]
then
    echo "Complete structure: PASS"
else
    echo "Complete structure: FAIL"
fi

echo "----------------------------"
echo "Test 13: No arguments handling"
echo "----------------------------"
rm -rf .mygit
user_output=$(python3 mygit-init arg1 arg2 2>&1)
correct_output="Initialized empty mygit repository in .mygit"
if [ "$user_output" = "$correct_output" ]
then
    echo "Ignores extra arguments: PASS"
else
    echo "Ignores extra arguments: FAIL"
    echo "Your output:"
    echo "$user_output"
    echo "Expected output:"
    echo "$correct_output"
fi

echo "----------------------------"
echo "All tests completed"
echo "----------------------------"