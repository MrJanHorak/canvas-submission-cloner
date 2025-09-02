#!/bin/bash

# This script automates the process of unzipping student submissions,
# extracting GitHub URLs, cloning the repositories, and installing dependencies.

# ==============================================================================
# --- Configuration ---
# ==============================================================================
SUBMISSIONS_DIR="html_submissions"
# The main directory for cloned repositories will be named dynamically.
# For example, if the lab is "ejs-lab", the directory will be "cloned_repos_ejs-lab".
CLONE_DIR=""

# ==============================================================================
# --- Setup and Unzipping ---
# ==============================================================================

# Ensure the submissions directory exists.
mkdir -p "$SUBMISSIONS_DIR"

# Check for and unzip submissions.zip if it exists.
if [ -f "submissions.zip" ]; then
    echo "Found submissions.zip, unzipping contents to '$SUBMISSIONS_DIR'..."
    unzip -o "submissions.zip" -d "$SUBMISSIONS_DIR"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to unzip submissions.zip. Exiting."
        exit 1
    fi
else
    echo "No submissions.zip found. Processing existing files in '$SUBMISSIONS_DIR'."
fi

# ==============================================================================
# --- Dynamic Directory Creation ---
# ==============================================================================

# Find the first HTML file to determine the lab name.
first_file=$(find "$SUBMISSIONS_DIR" -maxdepth 1 -name "*.html" | head -n 1)

if [ -n "$first_file" ]; then
    # Extract the first GitHub URL from the first file found.
    github_url=$(grep -oP 'url=\Khttps://[^"]+' "$first_file")

    if [ -n "$github_url" ]; then
        # Remove '/tree/main' and get the base repository link.
        repo_url=${github_url/\/tree\/main/}
        # Extract the lab name from the repository URL.
        lab_name=$(basename "$repo_url")
        
        # Define the main clone directory with the lab name.
        CLONE_DIR="cloned_repos_${lab_name}"
        mkdir -p "$CLONE_DIR"
        echo "Main cloning directory set to: '$CLONE_DIR'"
    else
        echo "Error: Could not find a GitHub URL in the first HTML file: $first_file"
        echo "Exiting as the lab name could not be determined."
        exit 1
    fi
else
    echo "No HTML files found in '$SUBMISSIONS_DIR'. Nothing to process."
    exit 0
fi

# ==============================================================================
# --- Main Processing Loop ---
# ==============================================================================

# Loop through each HTML file in the submissions directory.
for file in "$SUBMISSIONS_DIR"/*.html; do
    if [ -f "$file" ]; then
        echo "----------------------------------------------------"
        # Extract student name from the file name, assuming format "firstname_lastname_..."
        filename=$(basename -- "$file")
        student_name=$(echo "$filename" | cut -d'_' -f1-2)
        
        # Extract the GitHub URL from the HTML file.
        github_url=$(grep -oP 'url=\Khttps://[^"]+' "$file")
        
        if [ -n "$github_url" ]; then
            echo "Processing submission for $student_name..."
            
            # Remove '/tree/main' from the URL to get the base repository link.
            repo_url=${github_url/\/tree\/main/}
            
            # Extract the lab name from the repository URL.
            lab_name=$(basename "$repo_url")
            
            # Define the target directory for this specific clone.
            target_dir="$CLONE_DIR/${student_name}_${lab_name}"
            
            echo "Cloning $repo_url into $target_dir..."
            
            # Use 'git clone' with an optional check to prevent re-cloning.
            if [ ! -d "$target_dir" ]; then
                git clone "$repo_url" "$target_dir"
                
                # Check if cloning was successful.
                if [ $? -eq 0 ]; then
                    echo "Successfully cloned repository. Installing npm dependencies..."
                    
                    # Navigate into the cloned repository and run npm install.
                    cd "$target_dir"
                    npm install
                    
                    # Navigate back to the original directory.
                    cd - > /dev/null
                    
                    echo "npm install completed for $student_name."
                else
                    echo "Error: Failed to clone repository for $student_name. Check URL or permissions."
                fi
            else
                echo "Repository already exists at $target_dir. Skipping clone."
            fi
        else
            echo "Could not find a GitHub URL in $file. Skipping."
        fi
        echo ""
    fi
done

# ==============================================================================
# --- Cleanup ---
# ==============================================================================

# Delete the submissions directory after cloning all the repositories.
rm -rf "$SUBMISSIONS_DIR"
echo "Submission files in '$SUBMISSIONS_DIR' have been removed."

echo "Script finished. Cloned repositories are in the '$CLONE_DIR' directory."
