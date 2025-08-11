# Student Submission Cloner

This script automates the process of cloning student GitHub repositories from submission files. It is designed to work with submission files coming from Canvas that are HTML pages containing a link to the student's work on Github.

## Prerequisites

Before running this script, ensure you have the following installed on your system:

- [Git](https://git-scm.com/)
- [Node.js and npm](https://nodejs.org/)
- A Unix-like shell (e.g., Bash, Zsh)

## Setup

1.  **Place Submissions Zip**: Place the `submissions.zip` file, containing all the student submission HTML files, in the same directory as the `clone_submissions.sh` script.

2.  **File Naming Convention**: The script expects the HTML files inside the zip to be named in a way that the student's name can be extracted from the beginning of the filename. The format should be `firstname_lastname_...`.

3.  **Make Script Executable**: You may need to make the script executable by running the following command in your terminal:
    ```bash
    chmod +x clone_submissions.sh
    ```

## Usage

Once the setup is complete, you can run the script from your terminal:

```bash
./clone_submissions.sh
```

The script will then perform the following actions for each `.html` file it finds.

## What the Script Does

1.  **Creates Directories**: It creates two directories:
    *   `html_submissions`: to store the unzipped HTML files.
    *   `student_repos`: to store all the cloned repositories.

2.  **Unzips Submissions**: If a `submissions.zip` file is found, it unzips the contents into the `html_submissions` directory.

3.  **Parses HTML Files**: For each `.html` file in `html_submissions`, it:

    *   Extracts the student's name from the filename.
    *   Searches for a GitHub URL within the HTML content.

4.  **Clones Repositories**:

    *   It cleans the extracted URL to get the base repository link (e.g., removing `/tree/main`).
    *   It clones the repository into a dedicated folder inside `student_repos`, named `student_name_lab_name`.

5.  **Installs Dependencies**: After a repository is successfully cloned, the script navigates into the new directory and runs `npm install` to install any Node.js dependencies.

6.  **Outputs Progress**: The script will print its progress to the terminal, indicating which student's submission is being processed, whether the cloning was successful, and when `npm install` is complete. If a GitHub URL cannot be found in a file, it will skip that file and notify you.
