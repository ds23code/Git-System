#!/bin/dash
echo "----------------------------"
echo "mygit-checkout"
echo "----------------------------"

# Cleanup function for before tests
cleanup() {
    rm -rf .mygit
    rm -f testfile
}

cleanup

echo "----------------------------"
echo "Test 1: No .mygit directory"
echo "----------------------------"
user_output=$(./mygit-checkout trunk 2>&1)
correct_output="mygit-checkout: error: no .mygit directory found"
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
echo "Test 2: No branches directory"
echo "----------------------------"
mkdir -p .mygit
user_output=$(./mygit-checkout trunk 2>&1)
correct_output="mygit-checkout: error: no branches directory found"
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
echo "Test 3: Unknown branch"
echo "----------------------------"
mkdir -p .mygit/branches
user_output=$(./mygit-checkout unknown_branch 2>&1)
correct_output="mygit-checkout: error: unknown branch 'unknown_branch'"
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
echo "Test 4: Checkout to current branch"
echo "----------------------------"
echo "trunk" > .mygit/current_branch
echo "123" > .mygit/branches/trunk
user_output=$(./mygit-checkout trunk 2>&1)
correct_output="Already on 'trunk'"
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
echo "Test 5: Checkout to different branch, no conflicts"
echo "----------------------------"
mkdir -p .mygit/commits/123
echo "filecontent" > .mygit/commits/123/testfile
echo "123" > .mygit/branches/feature
echo "trunk" > .mygit/current_branch
echo "oldcontent" > testfile
mkdir -p .mygit/index
echo "oldcontent" > .mygit/index/testfile

user_output=$(./mygit-checkout feature 2>&1)
correct_output="Switched to branch 'feature'"

# Check file content updated
file_content=$(cat testfile 2>/dev/null)

if [ "$user_output" = "$correct_output" ] && 
   [ "$file_content" = "filecontent" ]; then
    echo "Output check: PASS"
else
    echo "Output check: FAIL"
    echo "Your output:"
    echo "$user_output"
    echo "File content:"
    echo "$file_content"
    echo "Correct output:"
    echo "$correct_output"
fi

echo "----------------------------"
echo "Test 6: Checkout with conflicting changes"
echo "----------------------------"
# Prepare conflicting files setup
echo "feature" > .mygit/current_branch
echo "123" > .mygit/branches/feature
echo "456" > .mygit/branches/bugfix
mkdir -p .mygit/index
echo "index content" > .mygit/index/conflictfile
echo "working different content" > conflictfile
mkdir -p .mygit/commits/456
echo "commit different content" > .mygit/commits/456/conflictfile

user_output=$(./mygit-checkout bugfix 2>&1)
correct_output_start="mygit-checkout: error: Your changes to the following 
files would be overwritten by checkout:"

case "$user_output" in
    "$correct_output_start"*)
        # Check if conflicting file name printed
        echo "$user_output" | grep -q conflictfile && echo "Output check: 
        PASS" || echo "Output check: FAIL: missing conflict file name"
        ;;
    *)
        echo "Output check: FAIL"
        echo "Your output:"
        echo "$user_output"
        echo "Expected output starting with:"
        echo "$correct_output_start"
        ;;
esac

echo "----------------------------"
echo "All tests completed"
echo "----------------------------"

# Clean up at end
cleanup