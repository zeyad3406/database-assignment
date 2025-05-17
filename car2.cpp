#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <ctime>
using namespace std;

void registerUser() {
    string username, password;
    cout << "Enter new username: ";
    cin >> username;
    cout << "Enter new password: ";
    cin >> password;

    ofstream file("users.txt", ios::app);
    file << username << " " << password << endl;
    file.close();

    cout << "User registered successfully!\n";
}

bool signIn() {
    string username, password, u, p;
    cout << "Username: ";
    cin >> username;
    cout << "Password: ";
    cin >> password;

    ifstream file("users.txt");
    while (file >> u >> p) {
        if (u == username && p == password) {
            cout << "Login successful!\n";
            return true;
        }
    }
    cout << "Login failed!\n";
    return false;
}

void addCustomer() {
    string id, name, phone;
    cout << "Customer ID: ";
    cin >> id;
    cout << "Name: ";
    cin.ignore();
    getline(cin, name);
    cout << "Phone: ";
    cin >> phone;

    ofstream file("customers.txt", ios::app);
    file << id << "," << name << "," << phone << endl;
    file.close();
}

void updateCustomer() {
    string id, name, phone, line, updated;
    cout << "Enter customer ID to update: ";
    cin >> id;

    ifstream inFile("customers.txt");
    ofstream outFile("temp.txt");

    bool found = false;
    while (getline(inFile, line)) {
        stringstream ss(line);
        string cid;
        getline(ss, cid, ',');

        if (cid == id) {
            found = true;
            cout << "Enter new name: ";
            cin.ignore();
            getline(cin, name);
            cout << "Enter new phone: ";
            cin >> phone;
            outFile << id << "," << name << "," << phone << endl;
        } else {
            outFile << line << endl;
        }
    }

    inFile.close();
    outFile.close();
    remove("customers.txt");
    rename("temp.txt", "customers.txt");

    if (!found) cout << "Customer not found.\n";
    else cout << "Customer updated.\n";
}

void deleteCustomer() {
    string id, line;
    cout << "Enter customer ID to delete: ";
    cin >> id;

    ifstream inFile("customers.txt");
    ofstream outFile("temp.txt");

    while (getline(inFile, line)) {
        if (line.substr(0, line.find(',')) != id) {
            outFile << line << endl;
        }
    }

    inFile.close();
    outFile.close();
    remove("customers.txt");
    rename("temp.txt", "customers.txt");

    cout << "Customer deleted if existed.\n";
}

void addCar() {
    string plate, model, customerId;
    cout << "Car Plate No: ";
    cin >> plate;
    cout << "Model: ";
    cin.ignore();
    getline(cin, model);
    cout << "Customer ID: ";
    cin >> customerId;

    ofstream file("cars.txt", ios::app);
    file << plate << "," << model << "," << customerId << endl;
    file.close();
}

void updateCar() {
    string plate, model, customerId, line;
    cout << "Enter plate number to update: ";
    cin >> plate;

    ifstream inFile("cars.txt");
    ofstream outFile("temp.txt");

    bool found = false;
    while (getline(inFile, line)) {
        stringstream ss(line);
        string pid;
        getline(ss, pid, ',');

        if (pid == plate) {
            found = true;
            cout << "New model: ";
            cin.ignore();
            getline(cin, model);
            cout << "New Customer ID: ";
            cin >> customerId;
            outFile << plate << "," << model << "," << customerId << endl;
        } else {
            outFile << line << endl;
        }
    }

    inFile.close();
    outFile.close();
    remove("cars.txt");
    rename("temp.txt", "cars.txt");

    if (!found) cout << "Car not found.\n";
    else cout << "Car updated.\n";
}

void deleteCar() {
    string plate, line;
    cout << "Enter plate number to delete: ";
    cin >> plate;

    ifstream inFile("cars.txt");
    ofstream outFile("temp.txt");

    while (getline(inFile, line)) {
        if (line.substr(0, line.find(',')) != plate) {
            outFile << line << endl;
        }
    }

    inFile.close();
    outFile.close();
    remove("cars.txt");
    rename("temp.txt", "cars.txt");

    cout << "Car deleted if existed.\n";
}

void addAccident() {
    string id, plate, description;
    cout << "Accident ID: ";
    cin >> id;
    cout << "Car Plate: ";
    cin >> plate;
    cout << "Description: ";
    cin.ignore();
    getline(cin, description);

    // Get current date
    time_t t = time(nullptr);
    tm* now = localtime(&t);
    stringstream date;
    date << (now->tm_year + 1900) << "-" << (now->tm_mon + 1) << "-" << now->tm_mday;

    ofstream file("accidents.txt", ios::app);
    file << id << "," << plate << "," << description << "," << date.str() << endl;
    file.close();
}

void updateAccident() {
    string id, line, plate, description;
    cout << "Enter accident ID to update: ";
    cin >> id;

    ifstream inFile("accidents.txt");
    ofstream outFile("temp.txt");

    bool found = false;
    while (getline(inFile, line)) {
        stringstream ss(line);
        string aid;
        getline(ss, aid, ',');

        if (aid == id) {
            found = true;
            cout << "New plate: ";
            cin >> plate;
            cout << "New description: ";
            cin.ignore();
            getline(cin, description);

            // Update date
            time_t t = time(nullptr);
            tm* now = localtime(&t);
            stringstream date;
            date << (now->tm_year + 1900) << "-" << (now->tm_mon + 1) << "-" << now->tm_mday;

            outFile << id << "," << plate << "," << description << "," << date.str() << endl;
        } else {
            outFile << line << endl;
        }
    }

    inFile.close();
    outFile.close();
    remove("accidents.txt");
    rename("temp.txt", "accidents.txt");

    if (!found) cout << "Accident not found.\n";
    else cout << "Accident updated.\n";
}

void viewAccidents() {
    string line;
    ifstream file("accidents.txt");
    cout << "Accidents:\n";
    while (getline(file, line)) {
        cout << line << endl;
    }
    file.close();
}

void monthlyReport() {
    string line;
    int month, year;
    cout << "Enter year: ";
    cin >> year;
    cout << "Enter month (1-12): ";
    cin >> month;

    ifstream file("accidents.txt");
    int count = 0;
    while (getline(file, line)) {
        stringstream ss(line);
        string id, plate, desc, date;
        getline(ss, id, ',');
        getline(ss, plate, ',');
        getline(ss, desc, ',');
        getline(ss, date, ',');

        int y, m, d;
        sscanf(date.c_str(), "%d-%d-%d", &y, &m, &d);
        if (y == year && m == month) count++;
    }
    cout << "Total accidents in " << year << "-" << month << ": " << count << endl;
}

int main() {
    int choice;
    do {
        cout << "\n--- Car Insurance System ---\n";
        cout << "1. Register\n2. Sign in\n3. Exit\nChoice: ";
        cin >> choice;
        if (choice == 1) registerUser();
        else if (choice == 2) {
            if (signIn()) {
                int opt;
                do {
                    cout << "\n--- Menu ---\n";
                    cout << "1. Add Customer\n2. Update Customer\n3. Delete Customer\n";
                    cout << "4. Add Car\n5. Update Car\n6. Delete Car\n";
                    cout << "7. Add Accident\n8. Update Accident\n9. View Accidents\n10. Monthly Report\n11. Logout\n";
                    cout << "Choice: ";
                    cin >> opt;
                    switch (opt) {
                        case 1: addCustomer(); break;
                        case 2: updateCustomer(); break;
                        case 3: deleteCustomer(); break;
                        case 4: addCar(); break;
                        case 5: updateCar(); break;
                        case 6: deleteCar(); break;
                        case 7: addAccident(); break;
                        case 8: updateAccident(); break;
                        case 9: viewAccidents(); break;
                        case 10: monthlyReport(); break;
                    }
                } while (opt != 11);
            }
        }
    } while (choice != 3);

    return 0;
}
