# Custom Version Control System

`mygit` is a **lightweight version control system** implemented in Python. It mimics core Git functionality, allowing users to track changes, manage branches, commit updates, and merge code. This project is ideal for learning the fundamentals of version control and experimenting with a simplified VCS.

---

## Features

* **Branch management** – create, switch, and merge branches.
* **Commit tracking** – save and view changes in a structured commit history.
* **Merge functionality** – merge commits or branches with error handling for conflicts or invalid inputs.
* **Error reporting** – clear messages when commands fail, e.g., missing arguments, unknown branches, or missing repository.
* **Testing suite** – shell scripts to verify proper behavior for various scenarios.

---

## Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd mygit
```

2. Ensure you have **Python 3** installed.
3. Make sure the scripts are executable:

```bash
chmod +x mygit-merge
```

---

## Usage

The `mygit` commands allow you to manage your repository. Below are examples of key commands:

### Initialize Repository

```bash
mkdir myproject
cd myproject
python3 mygit-init
```

This will create a `.mygit` folder containing commits, branches, and index.

### Add Commit

```bash
python3 mygit-commit -m "Initial commit"
```

### Merge Branch

```bash
python3 mygit-merge <branch-name|commit-number> -m "Merge message"
```

### Error Handling Examples

* Missing `.mygit` directory:

```
mygit-merge trunk -m "Merge commit"
# Output: mygit-merge: error: no .mygit directory found
```

* Merge non-existent branch:

```
mygit-merge no_such_branch -m "Merge message"
# Output: mygit-merge: error: unknown branch 'no_such_branch'
```

---

## Testing

Test scripts (e.g., `test-mygit-merge.sh`) verify the correct behavior of commands. They check for:

* Correct error messages
* Proper branch handling
* Merge operations
* Output validation

Run a test script like this:

```bash
./tests/test-mygit-merge.sh
```

---

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature`).
3. Make your changes.
4. Submit a pull request with a clear description of your changes.

---
