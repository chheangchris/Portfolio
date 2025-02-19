#include <iostream>
#include <string>
#include <list>
#include <ctime>

class TodoItem {
private:
    int id;
    std::string description;
    bool completed;

public:
    TodoItem() : id(0), description(""), completed(false) {}
    ~TodoItem() = default;

    bool create(std::string new_description) {
        id = rand() % 100 + 1;
        description = new_description;
        return true;
    }

    int getId() { return id; }
    std::string getDescription() { return description; }
    bool isCompleted() { return completed; }

    void setCompleted(bool val) { completed = val; }
};

int main()
{
    int input_id;
    char input_option;
    std::string input_description;
    std::string version = "v0.2.0";
    std::list<TodoItem> todoItems;
    std::list<TodoItem>::iterator it;

    srand(time(NULL));

    todoItems.clear();

    while (1) {
        // Clear the screen after the input prompt
        system("cls");
        
        // Display current state
        std::cout << "Todo List Maker - " << version << std::endl;
        std::cout << std::endl << std::endl;

        for (it = todoItems.begin(); it != todoItems.end(); it++) {
            std::string completed = it->isCompleted() ? "done" : "not done";
            std::cout << it->getId() << "|" << it->getDescription() << " | "
                << completed << std::endl;
        }

        if (todoItems.empty()) {
            std::cout << "Add your first todo!" << std::endl;
        }

        std::cout << std::endl << std::endl;

        std::cout << "[a]dd a new Todo" << std::endl;
        std::cout << "[r]emove a Todo" << std::endl;
        std::cout << "[c]omplete a Todo" << std::endl;
        std::cout << "[q]uit" << std::endl;

        std::cout << "choice: ";
        std::cin >> input_option;

        // Handle options
        if (input_option == 'q') {
            std::cout << "Have a great day!" << std::endl;
            break;
        }
        else if (input_option == 'a') {
            std::cout << "Add a new description: ";
            std::cin.ignore(); // Ignore leftover newline character from previous input
            std::getline(std::cin, input_description);

            TodoItem newItem;
            newItem.create(input_description);
            todoItems.push_back(newItem);
        }

        else if (input_option == 'c') {
            std::cout << "Enter id to mark completed: " << std::endl;
            std::cin >> input_id;

            for (it = todoItems.begin(); it != todoItems.end(); it++) {
                if (input_id == it->getId()) {
                    it->setCompleted(true);
                    break;
                }
            }
        }
        else if (input_option == 'r') {
            std::cout << "Enter id to remove a Todo: " << std::endl;
            std::cin >> input_id;

            for (it = todoItems.begin(); it != todoItems.end(); it++) {
                if (input_id == it->getId()) {
                    todoItems.erase(it);
                    std::cout << "Todo item removed successfully!" << std::endl;
                    break;
                }
            }
        }
    }

    return 0;
}
