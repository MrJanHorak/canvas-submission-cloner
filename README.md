# Student Submission Cloner

A friendly automation script that streamlines the process of cloning student GitHub repositories from Canvas submission files. This tool is designed to work with HTML submission files from Canvas that contain links to students' GitHub repositories.

## 🚀 Features

- **Smart Directory Naming**: Automatically creates organized directories based on the lab name extracted from GitHub URLs
- **Robust Error Handling**: Comprehensive error checking with helpful feedback messages
- **Duplicate Prevention**: Checks for existing repositories to avoid unnecessary re-cloning
- **Automatic Cleanup**: Removes temporary files after processing to keep your workspace tidy
- **Progress Tracking**: Clear, informative output showing the processing status for each student

## 📋 Prerequisites

Before running this script, ensure you have the following installed on your system:

- [Git](https://git-scm.com/) - For cloning repositories
- [Node.js and npm](https://nodejs.org/) - For installing project dependencies
- A Unix-like shell (Bash, Zsh, etc.) - The script is designed for Unix-based systems

## 🛠️ Setup

1. **Place Your Submissions**: Put the `submissions.zip` file (downloaded from Canvas) in the same directory as the `clone_submissions.sh` script.

2. **File Naming Convention**: The script expects HTML files to follow Canvas's naming convention where student names can be extracted from the filename (typically `firstname_lastname_...`).

3. **Make Script Executable**: Ensure the script has execute permissions:
   ```bash
   chmod +x clone_submissions.sh
   ```

## 🎯 Usage

Simply run the script from your terminal:

```bash
./clone_submissions.sh
```

**That's it!** The script will handle everything automatically. Sit back and watch as it processes each submission.

## 🔧 How It Works

The script follows a smart, step-by-step process:

### 1. **Intelligent Setup**

- Creates a temporary `html_submissions` directory for processing
- Automatically unzips `submissions.zip` if present, or works with existing HTML files
- Determines the lab name by analyzing the first GitHub URL found

### 2. **Dynamic Directory Creation**

- Creates a main directory named `cloned_repos_[lab-name]` (e.g., `cloned_repos_ejs-lab`)
- This keeps different labs organized and prevents mixing assignments

### 3. **Smart Processing**

For each student submission, the script:

- Extracts the student's name from the filename
- Finds and validates the GitHub URL in the HTML content
- Cleans the URL (removes `/tree/main` suffixes)
- Creates a unique directory: `[student-name]_[lab-name]`

### 4. **Repository Management**

- Clones each repository into its dedicated directory
- Skips repositories that already exist (prevents duplicate work)
- Automatically runs `npm install` to set up dependencies
- Provides clear success/failure feedback for each operation

### 5. **Cleanup**

- Removes the temporary `html_submissions` directory
- Leaves you with a clean, organized workspace

## 📁 Output Structure

After running the script, you'll have a well-organized directory structure:

```
cloned_repos_[lab-name]/
├── alice_smith_lab-name/
│   ├── [student's project files]
│   └── node_modules/
├── bob_jones_lab-name/
│   ├── [student's project files]
│   └── node_modules/
└── ...
```

## 💡 Helpful Tips

- **First Run**: The script automatically detects the lab name from the first valid GitHub URL it finds
- **Resume Capability**: If the script is interrupted, you can run it again - it won't re-clone existing repositories
- **Error Handling**: The script continues processing other submissions even if one fails
- **Progress Monitoring**: Watch the terminal output to see real-time progress and any issues

## 🐛 Troubleshooting

If you encounter issues:

- **No GitHub URLs found**: Check that your HTML files contain properly formatted GitHub links
- **Permission errors**: Ensure you have write permissions in the current directory
- **Git clone failures**: Verify the GitHub URLs are accessible and public
- **npm install issues**: Some student projects may have dependency problems - these are logged individually

## Admissions

This Readme file was automatically generated, everything expect this line. Claude Sonnet 4 in Agent mode summarized my script in a friendly fairly easy to understanding manner, however definitely left that typical AI-tone. But hey, its a readme and AI is really good at making README files. 

The script is a mix of my writing it, playing around and then when I liked what it was doing fine tuning some elements in Gemini. Have fun with it, I hope it is useful and will help speed up your grading process! 