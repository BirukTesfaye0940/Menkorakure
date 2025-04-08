# Project Guidelines for Collaboration

Welcome to the **Menkorakure** project! This document outlines the steps and rules to help you collaborate effectively with your team. Please follow these instructions carefully to ensure a smooth workflow and clean codebase. Remember, teamwork and organization are key to success in this project!

---

## Project Structure

### Branching System
- **Main Branch**:  
  The `main` branch is the final and stable version of the project.  
  **It is sacred** and should only be updated after all levels are completed and reviewed.
  
- **Level Branches**:  
  There are six level branches: `level1`, `level2`, `level3`, `level4`, `level5`, and `level6`.  
  Each level branch acts as the main branch for tasks related to that specific level.

---

## How to Contribute to the Project

### Step-by-Step Instructions
1. **Start by Pulling Changes from Your Level Branch**:  
   Always pull the latest changes from your level branch before starting your task.  
   ```bash
   git checkout levelX   # Replace X with your level number (1-6)
   git pull origin levelX
   ```

2. **Create a New Branch for Your Task**:  
   While on your level branch, create a new branch for your specific task.  
   ```bash
   git checkout -b feature/task-name
   ```

3. **Work on Your Task**:  
   Make the necessary changes for your task. Keep the code clean and organized—don’t put everything into one file. Maintain a good folder structure and separation of concerns.  
   Refer to [this project](https://github.com/InvadingOctopus/comedot) as an example of a clean and well-structured repository.

4. **Push Your Task Branch**:  
   Push your task branch to the remote repository.  
   ```bash
   git push origin feature/task-name
   ```

5. **Send a Pull Request (PR)**:  
   - Send a PR from your task branch (e.g., `feature/task-name`) to your respective level branch (e.g., `levelX`).
   - Write a clear title and description for your PR explaining what changes you made.

6. **Review and Merge**:  
   - Someone from your level (or the level manager) will review your PR.  
   - If everything looks good, they will merge it into the level branch.  
   - If there are no conflicts, you may also merge your PR to the level branch yourself (if allowed by your team).

---

## Merging to the Main Branch

- Once all tasks in a level are completed, the level branch (e.g., `level1`) will send a PR to the `main` branch.
- The **project managers** will review the changes to ensure everything is working correctly.
- After thorough testing and review, they will merge the level branch into the `main` branch.

---

## Reminders for Everyone

- **Collaborate Smartly**: Always pull changes from your level branch before starting a new task to avoid conflicts.
- **Branching Discipline**: Always create your task branch from your level branch, **not from `main`**.
- **Keep it Clean**: Follow a proper folder structure and avoid putting everything into one file. This will make integration easier later.
- **Separation of Concerns**: Keep related files and code together while ensuring tasks are modular and easy to understand.

---

### Example Workflow
1. Pull changes from `levelX`:
   ```bash
   git checkout levelX
   git pull origin levelX
   ```

2. Create a branch for your task:
   ```bash
   git checkout -b feature/task-name
   ```

3. Work on your task and commit your changes:
   ```bash
   git add .
   git commit -m "Add feature/task-name"
   ```

4. Push your branch:
   ```bash
   git push origin feature/task-name
   ```

5. Open a PR to `levelX` and wait for review.

---

### Final Note
We understand that time is limited, but try your best to keep the project clean and organized. Following these guidelines will make integration much easier later. Let’s work together and do our best to make this project a success!

Good luck, everyone! 🎉
