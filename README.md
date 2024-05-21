# shellprojet
# Todo Script

This script allows you to manage your todo tasks. Each task has a unique identifier, a title, a description, a location, a due date and time, and a completion marker. The script can create, update, delete, show, list, and search tasks.

## Design Choices

- **Data Storage**: Tasks are stored in a text file (`todo.txt`) with each task on a new line. The task fields are separated by the `|` character.
- **Code Organization**: The script is organized into functions for each of the main actions: create, update, delete, show, list, and search tasks. This modular approach makes the code easier to maintain and extend.

## How to Run

1. **Make the script executable**:
    ```bash
    chmod +x todo.sh
    ```

2. **Run the script** with one of the following commands:
    - `./todo.sh` - Lists completed and uncompleted tasks of the current day.
    - `./todo.sh create` - Creates a new task.
    - `./todo.sh update` - Updates an existing task.
    - `./todo.sh delete` - Deletes a task.
    - `./todo.sh show` - Shows a task.
    - `./todo.sh list` - Lists tasks of a given day.
    - `./todo.sh search` - Searches for a task by title.

3. **Error Handling**: The script checks for required fields and handles errors by displaying appropriate messages to the user.

## Example Usage

- To create a new task:
    ```bash
    ./todo.sh create
    ```

- To update an existing task:
    ```bash
    ./todo.sh update
    ```

- To delete a task:
    ```bash
    ./todo.sh delete
    ```

- To show a task:
    ```bash
    ./todo.sh show
    ```

- To list tasks of a given day:
    ```bash
    ./todo.sh list
    ```

- To search for a task by title:
    ```bash
    ./todo.sh search
    ```

## Note

Make sure the `todo.txt` file is in the same directory as the script, or modify the `TODO_FILE` variable in the script to point to the correct file location.
