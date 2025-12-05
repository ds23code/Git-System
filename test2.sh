#!/bin/dash
echo "----------------------------"
echo "mygit-commit"
echo "----------------------------"

echo "----------------------------"
echo "Test 1: No .mygit repository"
echo "----------------------------"
rm -rf .mygit
user_output=$(python3 mygit-commit -m "test message" 2>&1)
correct_output="mygit-commit: error: no .mygit directory found"
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
user_output=$(python3 mygit-commit 2>&1)
correct_output="usage: mygit-commit [-a] -m commit-message"
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
echo "Test 3: Missing -m flag"
echo "----------------------------"
user_output=$(python3 mygit-commit "test message" 2>&1)
correct_output="usage: mygit-commit [-a] -m commit-message"
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
echo "Test 4: Missing commit message"
echo "----------------------------"
user_output=$(python3 mygit-commit -m 2>&1)
correct_output="usage: mygit-commit [-a] -m commit-message"
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
echo "Test 5: Nothing to commit (no index)"
echo "----------------------------"
rm -rf .mygit
mkdir -p .mygit/commits
echo "0" > .mygit/commit_count
user_output=$(python3 mygit-commit -m "test message" 2>&1)
correct_output="nothing to commit"
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
echo "Test 6: Nothing to commit (empty index)"
echo "----------------------------"
rm -rf .mygit
mkdir -p .mygit/index
mkdir -p .mygit/commits
echo "0" > .mygit/commit_count
user_output=$(python3 mygit-commit -m "test message" 2>&1)
correct_output="nothing to commit"
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
echo "Test 7: First commit with staged file"
echo "----------------------------"
rm -rf .mygit
mkdir -p .mygit/index
mkdir -p .mygit/commits
mkdir -p .mygit/branches
echo "0" > .mygit/commit_count
echo "trunk" > .mygit/current_branch
echo "test content" > .mygit/index/file1.txt
user_output=$(python3 mygit-commit -m "first commit" 2>&1)
correct_output="Committed as commit 0"
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
if [ -f ".mygit/commits/0/file1.txt" ]
then
    echo "File committed: PASS"
else
    echo "File committed: FAIL"
fi
if [ "$(cat .mygit/commit_count)" = "1" ]
then
    echo "Commit count updated: PASS"
else
    echo "Commit count updated: FAIL"
fi
if [ -f ".mygit/commits/0/commit_info" ]
then
    echo "Commit info created: PASS"
else
    echo "Commit info created: FAIL"
fi

echo "----------------------------"
echo "Test 8: Second commit with new file"
echo "----------------------------"
echo "second file content" > .mygit/index/file2.txt
user_output=$(python3 mygit-commit -m "second commit" 2>&1)
correct_output="Committed as commit 1"
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
if [ -f ".mygit/commits/1/file1.txt" ] && [ -f ".mygit/commits/1/file2.txt" ]
then
    echo "Both files committed: PASS"
else
    echo "Both files committed: FAIL"
fi
if [ "$(cat .mygit/commit_count)" = "2" ]
then
    echo "Commit count updated: PASS"
else
    echo "Commit count updated: FAIL"
fi

echo "----------------------------"
echo "Test 9: Nothing to commit (identical to last)"
echo "----------------------------"
user_output=$(python3 mygit-commit -m "duplicate commit" 2>&1)
correct_output="nothing to commit"
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
if [ "$(cat .mygit/commit_count)" = "2" ]
then
    echo "Commit count unchanged: PASS"
else
    echo "Commit count unchanged: FAIL"
fi

echo "----------------------------"
echo "Test 10: Commit with modified file"
echo "----------------------------"
echo "modified content" > .mygit/index/file1.txt
user_output=$(python3 mygit-commit -m "modified file" 2>&1)
correct_output="Committed as commit 2"
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
if [ "$(cat .mygit/commits/2/file1.txt)" = "modified content" ]
then
    echo "Modified content committed: PASS"
else
    echo "Modified content committed: FAIL"
fi

echo "----------------------------"
echo "Test 11: Commit with file removal"
echo "----------------------------"
rm .mygit/index/file2.txt
user_output=$(python3 mygit-commit -m "removed file2" 2>&1)
correct_output="Committed as commit 3"
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
if [ -f ".mygit/commits/3/file1.txt" ] && [ ! -f ".mygit/commits/3/file2.txt" ]
then
    echo "File removal committed: PASS"
else
    echo "File removal committed: FAIL"
fi

echo "----------------------------"
echo "Test 12: Commit with -a flag"
echo "----------------------------"
rm -rf .mygit
mkdir -p .mygit/index
mkdir -p .mygit/commits/0
mkdir -p .mygit/branches
echo "1" > .mygit/commit_count
echo "trunk" > .mygit/current_branch
echo "original content" > .mygit/commits/0/tracked_file.txt
echo '{"message": "initial", "files": ["tracked_file.txt"]}' > .mygit/commits/0/commit_info
echo "modified content in working dir" > tracked_file.txt
user_output=$(python3 mygit-commit -a -m "auto staged commit" 2>&1)
correct_output="Committed as commit 1"
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
if [ "$(cat .mygit/commits/1/tracked_file.txt)" = "modified content in working dir" ]
then
    echo "Auto-staged content committed: PASS"
else
    echo "Auto-staged content committed: FAIL"
fi
rm tracked_file.txt

echo "----------------------------"
echo "Test 13: Commit with nested directories"
echo "----------------------------"
rm -rf .mygit
mkdir -p .mygit/index/subdir
mkdir -p .mygit/commits
mkdir -p .mygit/branches
echo "0" > .mygit/commit_count
echo "trunk" > .mygit/current_branch
echo "nested content" > .mygit/index/subdir/nested_file.txt
user_output=$(python3 mygit-commit -m "nested file commit" 2>&1)
correct_output="Committed as commit 0"
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
if [ -f ".mygit/commits/0/subdir/nested_file.txt" ]
then
    echo "Nested file committed: PASS"
else
    echo "Nested file committed: FAIL"
fi

echo "----------------------------"
echo "Test 14: Branch file updated"
echo "----------------------------"
if [ "$(cat .mygit/branches/trunk)" = "1" ]
then
    echo "Branch file updated: PASS"
else
    echo "Branch file updated: FAIL"
    echo "Expected: 1"
    echo "Got: $(cat .mygit/branches/trunk)"
fi

echo "----------------------------"
echo "Test 15: Commit all tracked files removed"
echo "----------------------------"
rm -rf .mygit
mkdir -p .mygit/index
mkdir -p .mygit/commits/0
mkdir -p .mygit/branches
echo "1" > .mygit/commit_count
echo "trunk" > .mygit/current_branch
echo "file content" > .mygit/commits/0/tracked_file.txt
echo '{"message": "initial", "files": ["tracked_file.txt"]}' > .mygit/commits/0/commit_info
# Index is empty (file was removed)
user_output=$(python3 mygit-commit -m "removed all files" 2>&1)
correct_output="Committed as commit 1"
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
if [ ! -f ".mygit/commits/1/tracked_file.txt" ]
then
    echo "All files removed commit: PASS"
else
    echo "All files removed commit: FAIL"
fi

echo "----------------------------"
echo "Test 16: Multiple files with same content as last commit"
echo "----------------------------"
rm -rf .mygit
mkdir -p .mygit/index
mkdir -p .mygit/commits/0
mkdir -p .mygit/branches
echo "1" > .mygit/commit_count
echo "trunk" > .mygit/current_branch
echo "content1" > .mygit/commits/0/file1.txt
echo "content2" > .mygit/commits/0/file2.txt
echo '{"message": "initial", "files": ["file1.txt", "file2.txt"]}' > .mygit/commits/0/commit_info
echo "content1" > .mygit/index/file1.txt
echo "content2" > .mygit/index/file2.txt
user_output=$(python3 mygit-commit -m "no changes" 2>&1)
correct_output="nothing to commit"
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