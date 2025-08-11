#!/bin/bash

# Directory where the HTML files are located
SUBMISSIONS_DIR="."

# Directory to store the cloned repositories
CLONE_DIR="student_repos"
mkdir -p "$CLONE_DIR"

# Loop through each HTML file in the submissions directory
for file in "$SUBMISSIONS_DIR"/*.html; do
    if [ -f "$file" ]; then
        # Extract student name from the file name
        # Assumes the format "firstname_lastname_..."
        filename=$(basename -- "$file")
        student_name=$(echo "$filename" | cut -d'_' -f1-2)
        
        # Extract the GitHub URL from the HTML file
        # This looks for the 'url=' attribute in the meta tag
        github_url=$(grep -oP 'url=\Khttps://[^"]+' "$file")
        
        if [ -n "$github_url" ]; then
            echo "Processing submission for $student_name..."
            
            # Remove '/tree/main' from the URL to get the base repository link
            repo_url=${github_url/\/tree\/main/}
            
            # Extract the lab name from the repository URL
            # This assumes the lab name is the last part of the URL path
            lab_name=$(basename "$repo_url")
            
            # Define the target directory for the clone
            target_dir="$CLONE_DIR/${student_name}_${lab_name}"
            
            echo "Cloning $repo_url into $target_dir..."
            git clone "$repo_url" "$target_dir"
            
            # Check if cloning was successful
            if [ $? -eq 0 ]; then
                echo "Successfully cloned repository. Installing npm dependencies..."
                
                # Navigate into the cloned repository and run npm install
                cd "$target_dir"
                npm install
                
                # Navigate back to the original directory
                cd -
                
                echo "npm install completed for $student_name."
            else
                echo "Failed to clone repository for $student_name."
            fi
        else
            echo "Could not find a GitHub URL in $file. Skipping."
        fi
    fi
done

echo "Script finished."