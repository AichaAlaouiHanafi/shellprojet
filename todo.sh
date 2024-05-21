#!/bin/bash

TODO_FILE="todo.txt"

# Function to display an error message
function error() {
    echo "$1" >&2
}

# Function to display usage
function usage() {
    echo "Usage: $0 [create|update|delete|show|list|search]"
}

# Function to create a new task
function create_task() {
    read -p "Enter title: " title
    if [[ -z "$title" ]]; then
        error "Title is required."
        exit 1
    fi

    read -p "Enter due date (YYYY-MM-DD): " due_date
    if [[ -z "$due_date" ]]; then
        error "Due date is required."
        exit 1
    fi

    read -p "Enter description (optional): " description
    read -p "Enter location (optional): " location
    read -p "Enter due time (HH:MM, optional): " due_time

    id=$(($(tail -n 1 $TODO_FILE | cut -d '|' -f 1) + 1))
    echo "$id|$title|$description|$location|$due_date|$due_time|0" >> $TODO_FILE
    echo "Task $id created."
}

# Function to update an existing task
function update_task() {
    read -p "Enter task ID to update: " id
    task=$(grep "^$id|" $TODO_FILE)
    if [[ -z "$task" ]]; then
        error "Task $id not found."
        exit 1
    fi

    IFS='|' read -r -a task_arr <<< "$task"

    read -p "Enter new title (leave blank to keep current): " title
    read -p "Enter new due date (YYYY-MM-DD, leave blank to keep current): " due_date
    read -p "Enter new description (leave blank to keep current): " description
    read -p "Enter new location (leave blank to keep current): " location
    read -p "Enter new due time (HH:MM, leave blank to keep current): " due_time
    read -p "Enter new completion status (0 for incomplete, 1 for complete, leave blank to keep current): " completed

    title=${title:-${task_arr[1]}}
    description=${description:-${task_arr[2]}}
    location=${location:-${task_arr[3]}}
    due_date=${due_date:-${task_arr[4]}}
    due_time=${due_time:-${task_arr[5]}}
    completed=${completed:-${task_arr[6]}}

    new_task="$id|$title|$description|$location|$due_date|$due_time|$completed"
    sed -i "s/^$task\$/$new_task/" $TODO_FILE
    echo "Task $id updated."
}

# Function to delete a task
function delete_task() {
    read -p "Enter task ID to delete: " id
    task=$(grep "^$id|" $TODO_FILE)
    if [[ -z "$task" ]]; then
        error "Task $id not found."
        exit 1
    fi

    sed -i "/^$id|/d" $TODO_FILE
    echo "Task $id deleted."
}

# Function to show a task
function show_task() {
    read -p "Enter task ID to show: " id
    task=$(grep "^$id|" $TODO_FILE)
    if [[ -z "$task" ]]; then
        error "Task $id not found."
        exit 1
    fi

    IFS='|' read -r -a task_arr <<< "$task"
    echo "ID: ${task_arr[0]}"
    echo "Title: ${task_arr[1]}"
    echo "Description: ${task_arr[2]}"
    echo "Location: ${task_arr[3]}"
    echo "Due Date: ${task_arr[4]}"
    echo "Due Time: ${task_arr[5]}"
    echo "Completed: ${task_arr[6]}"
}

# Function to list tasks of a given day
function list_tasks() {
    read -p "Enter date (YYYY-MM-DD) to list tasks: " date
    completed_tasks=$(grep "|$date|.*|1$" $TODO_FILE)
    uncompleted_tasks=$(grep "|$date|.*|0$" $TODO_FILE)

    echo "Completed tasks:"
    echo "$completed_tasks" | while IFS='|' read -r id title description location due_date due_time completed; do
        echo "ID: $id, Title: $title"
    done

    echo
    echo "Uncompleted tasks:"
    echo "$uncompleted_tasks" | while IFS='|' read -r id title description location due_date due_time completed; do
        echo "ID: $id, Title: $title"
    done
}

# Function to search for a task by title
function search_tasks() {
    read -p "Enter title to search: " title
    tasks=$(grep "|$title|" $TODO_FILE)

    echo "$tasks" | while IFS='|' read -r id title description location due_date due_time completed; do
        echo "ID: $id, Title: $title"
    done
}

# Function to list tasks of the current day
function list_today_tasks() {
    date=$(date +%Y-%m-%d)
    completed_tasks=$(grep "|$date|.*|1$" $TODO_FILE)
    uncompleted_tasks=$(grep "|$date|.*|0$" $TODO_FILE)

    echo "Completed tasks:"
    echo "$completed_tasks" | while IFS='|' read -r id title description location due_date due_time completed; do
        echo "ID: $id, Title: $title"
    done

    echo
    echo "Uncompleted tasks:"
    echo "$uncompleted_tasks" | while IFS='|' read -r id title description location due_date due_time completed; do
        echo "ID: $id, Title: $title"
    done
}

# Main script
if [[ ! -f $TODO_FILE ]]; then
    touch $TODO_FILE
fi

if [[ $# -eq 0 ]]; then
    list_today_tasks
    exit 0
fi

case $1 in
    create)
        create_task
        ;;
    update)
        update_task
        ;;
    delete)
        delete_task
        ;;
    show)
        show_task
        ;;
    list)
        list_tasks
        ;;
    search)
        search_tasks
        ;;
    *)
        usage
        ;;
esac

