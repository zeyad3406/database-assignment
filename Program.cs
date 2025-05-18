// Full working code with support for: users, customers, cars, accidents, insurance_policies, monthly_reports, driver_licenses

using System;
using System.Data.SqlClient;
using System.Runtime.Remoting.Contexts;
using static System.Net.Mime.MediaTypeNames;

class Program
{
    static string connectionString = @"Data Source=HUSSEIN\MSSQLSERVER01;Initial Catalog=CarInsuranceSystem2;Integrated Security=True;Encrypt=True;TrustServerCertificate=True;";

    static void TestConnection()
    {
        try
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                Console.WriteLine("Connected to Database: " + conn.Database);
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("Connection failed: " + ex.Message);
        }
    }

    static void RegisterUser()
    {
        Console.Write("Enter new username: ");
        string username = Console.ReadLine();
        Console.Write("Enter new password: ");
        string password = Console.ReadLine();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            string query = "INSERT INTO users (username, password) VALUES (@username, @password)";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@username", username);
                cmd.Parameters.AddWithValue("@password", password);
                cmd.ExecuteNonQuery();
                Console.WriteLine("User registered successfully!");
            }
        }
    }

    static bool SignIn()
    {
        Console.Write("Username: ");
        string username = Console.ReadLine();
        Console.Write("Password: ");
        string password = Console.ReadLine();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            string query = "SELECT COUNT(*) FROM users WHERE username = @username AND password = @password";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@username", username);
                cmd.Parameters.AddWithValue("@password", password);
                int count = (int)cmd.ExecuteScalar();
                if (count > 0)
                {
                    Console.WriteLine("Login successful!");
                    return true;
                }
            }
        }
        Console.WriteLine("Login failed!");
        return false;
    }

    static void AddCustomer()
    {
        Console.Write("Customer ID: ");
        int id = int.Parse(Console.ReadLine());
        Console.Write("Name: ");
        string name = Console.ReadLine();
        Console.Write("Phone: ");
        string phone = Console.ReadLine();
        Console.Write("Email: ");
        string email = Console.ReadLine();
        Console.Write("Address: ");
        string address = Console.ReadLine();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            string query = "INSERT INTO customers (id, name, phone, email, address) VALUES (@id, @name, @phone, @email, @address)";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@id", id);
                cmd.Parameters.AddWithValue("@name", name);
                cmd.Parameters.AddWithValue("@phone", phone);
                cmd.Parameters.AddWithValue("@email", email);
                cmd.Parameters.AddWithValue("@address", address);
                cmd.ExecuteNonQuery();
                Console.WriteLine("Customer added.");
            }
        }
    }

    static void DeleteCustomer()
    {
        Console.Write("Enter Customer ID to delete: ");
        int id = int.Parse(Console.ReadLine());

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand("DELETE FROM customers WHERE id = @id", conn);
            cmd.Parameters.AddWithValue("@id", id);
            int result = cmd.ExecuteNonQuery();
            Console.WriteLine(result > 0 ? "Customer deleted." : "Customer not found.");
        }
    }

    static void UpdateCustomer()
    {
        Console.Write("Enter Customer ID: ");
        int id = int.Parse(Console.ReadLine());
        Console.Write("New Name: ");
        string name = Console.ReadLine();
        Console.Write("New Phone: ");
        string phone = Console.ReadLine();
        Console.Write("New Email: ");
        string email = Console.ReadLine();
        Console.Write("New Address: ");
        string address = Console.ReadLine();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(@"UPDATE customers SET 
                                          name = @name, phone = @phone, 
                                          email = @email, address = @address 
                                          WHERE id = @id", conn);
            cmd.Parameters.AddWithValue("@id", id);
            cmd.Parameters.AddWithValue("@name", name);
            cmd.Parameters.AddWithValue("@phone", phone);
            cmd.Parameters.AddWithValue("@email", email);
            cmd.Parameters.AddWithValue("@address", address);

            int result = cmd.ExecuteNonQuery();
            Console.WriteLine(result > 0 ? "Customer updated." : "Customer not found.");
        }
    }


    static void AddCar()
    {
        Console.Write("Plate: ");
        string plate = Console.ReadLine();
        Console.Write("Model: ");
        string model = Console.ReadLine();
        Console.Write("Year: ");
        int year = int.Parse(Console.ReadLine());
        Console.Write("Status (1=insured, 0=not): ");
        int status = int.Parse(Console.ReadLine());
        Console.Write("Customer ID: ");
        int customerId = int.Parse(Console.ReadLine());

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            string query = "INSERT INTO cars (plate, model, year, status, customer_id) VALUES (@plate, @model, @year, @status, @customer_id)";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@plate", plate);
                cmd.Parameters.AddWithValue("@model", model);
                cmd.Parameters.AddWithValue("@year", year);
                cmd.Parameters.AddWithValue("@status", status);
                cmd.Parameters.AddWithValue("@customer_id", customerId);
                cmd.ExecuteNonQuery();
                Console.WriteLine("Car added.");
            }
        }
    }

    static void DeleteCar()
    {
        Console.Write("Enter Car Plate to delete: ");
        string plate = Console.ReadLine();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand("DELETE FROM cars WHERE plate = @plate", conn);
            cmd.Parameters.AddWithValue("@plate", plate);
            int result = cmd.ExecuteNonQuery();
            Console.WriteLine(result > 0 ? "Car deleted." : "Car not found.");
        }
    }

    static void UpdateCar()
    {
        Console.Write("Enter Car Plate: ");
        string plate = Console.ReadLine();
        Console.Write("New Model: ");
        string model = Console.ReadLine();
        Console.Write("New Year: ");
        int year = int.Parse(Console.ReadLine());
        Console.Write("Insured? (1 = Yes, 0 = No): ");
        int status = int.Parse(Console.ReadLine());

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(@"UPDATE cars 
                                          SET model = @model, year = @year, status = @status 
                                          WHERE plate = @plate", conn);
            cmd.Parameters.AddWithValue("@plate", plate);
            cmd.Parameters.AddWithValue("@model", model);
            cmd.Parameters.AddWithValue("@year", year);
            cmd.Parameters.AddWithValue("@status", status);

            int result = cmd.ExecuteNonQuery();
            Console.WriteLine(result > 0 ? "Car updated." : "Car not found.");
        }
    }


    static void AddAccident()
    {
        Console.Write("Accident ID: ");
        string id = Console.ReadLine();
        Console.Write("Car Plate: ");
        string plate = Console.ReadLine();
        Console.Write("Damage Cost: ");
        decimal cost = decimal.Parse(Console.ReadLine());
        Console.Write("Description: ");
        string description = Console.ReadLine();
        string date = DateTime.Now.ToString("yyyy-MM-dd");

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            string query = "INSERT INTO accidents (id, car_plate, damage_cost, description, date) VALUES (@id, @plate, @cost, @desc, @date)";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@id", id);
                cmd.Parameters.AddWithValue("@plate", plate);
                cmd.Parameters.AddWithValue("@cost", cost);
                cmd.Parameters.AddWithValue("@desc", description);
                cmd.Parameters.AddWithValue("@date", date);
                cmd.ExecuteNonQuery();
                Console.WriteLine("Accident added.");
            }
        }
    }

    static void UpdateAccident()
    {
        Console.Write("Enter Accident ID: ");
        string id = Console.ReadLine();
        Console.Write("New Description: ");
        string desc = Console.ReadLine();
        Console.Write("New Damage Cost: ");
        decimal cost = decimal.Parse(Console.ReadLine());

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(@"UPDATE accidents 
                                          SET description = @desc, damage_cost = @cost 
                                          WHERE id = @id", conn);
            cmd.Parameters.AddWithValue("@id", id);
            cmd.Parameters.AddWithValue("@desc", desc);
            cmd.Parameters.AddWithValue("@cost", cost);

            int result = cmd.ExecuteNonQuery();
            Console.WriteLine(result > 0 ? "Accident updated." : "Accident not found.");
        }
    }

    static void ViewAccidents()
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand("SELECT * FROM accidents", conn);
            SqlDataReader reader = cmd.ExecuteReader();

            while (reader.Read())
            {
                Console.WriteLine($"ID: {reader["id"]}, Plate: {reader["car_plate"]}, Cost: {reader["damage_cost"]}, Date: {reader["date"]}, Desc: {reader["description"]}");
            }
        }
    }


    static void AddInsurancePolicy()
    {
        Console.Write("Policy ID: ");
        string id = Console.ReadLine();
        Console.Write("Start Date (yyyy-mm-dd): ");
        string start = Console.ReadLine();
        Console.Write("End Date (yyyy-mm-dd): ");
        string end = Console.ReadLine();
        Console.Write("Coverage Type: ");
        string type = Console.ReadLine();
        Console.Write("Premium Amount: ");
        decimal premium = decimal.Parse(Console.ReadLine());

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            string query = "INSERT INTO insurance_policies VALUES (@id, @start, @end, @type, @premium)";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@id", id);
                cmd.Parameters.AddWithValue("@start", start);
                cmd.Parameters.AddWithValue("@end", end);
                cmd.Parameters.AddWithValue("@type", type);
                cmd.Parameters.AddWithValue("@premium", premium);
                cmd.ExecuteNonQuery();
                Console.WriteLine("Policy added.");
            }
        }
    }

    static void AddMonthlyReport()
    {
        Console.Write("Month (e.g. 2024-05): ");
        string month = Console.ReadLine();
        Console.Write("Total Accidents: ");
        int total = int.Parse(Console.ReadLine());
        Console.Write("Generated By: ");
        string by = Console.ReadLine();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            string query = "INSERT INTO monthly_reports (Month, totalAccidents, generatedDate, generatedBy) VALUES (@month, @total, GETDATE(), @by)";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@month", month);
                cmd.Parameters.AddWithValue("@total", total);
                cmd.Parameters.AddWithValue("@by", by);
                cmd.ExecuteNonQuery();
                Console.WriteLine("Monthly report added.");
            }
        }
    }

    static void GenerateMonthlyReport()
    {
        Console.Write("Enter month (yyyy-MM): ");
        string month = Console.ReadLine();
        Console.Write("Enter username who generated this: ");
        string user = Console.ReadLine();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(@"SELECT COUNT(*) FROM accidents 
                                          WHERE FORMAT(date, 'yyyy-MM') = @month", conn);
            cmd.Parameters.AddWithValue("@month", month);
            int count = (int)cmd.ExecuteScalar();

            SqlCommand insertCmd = new SqlCommand(@"INSERT INTO monthly_reports 
                        (Month, totalAccidents, generatedDate, generatedBy) 
                        VALUES (@month, @count, GETDATE(), @user)", conn);
            insertCmd.Parameters.AddWithValue("@month", month);
            insertCmd.Parameters.AddWithValue("@count", count);
            insertCmd.Parameters.AddWithValue("@user", user);
            insertCmd.ExecuteNonQuery();

            Console.WriteLine($"Report generated for {month}: {count} accidents.");
        }
    }


    static void AddDriverLicense()
    {
        Console.Write("Customer ID: ");
        int id = int.Parse(Console.ReadLine());
        Console.Write("License Number: ");
        string number = Console.ReadLine();
        Console.Write("Issue Date (yyyy-mm-dd): ");
        string issue = Console.ReadLine();
        Console.Write("Expiry Date (yyyy-mm-dd): ");
        string expiry = Console.ReadLine();
        Console.Write("License Type: ");
        string type = Console.ReadLine();

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            string query = "INSERT INTO driver_licenses VALUES (@id, @number, @issue, @expiry, @type)";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@id", id);
                cmd.Parameters.AddWithValue("@number", number);
                cmd.Parameters.AddWithValue("@issue", issue);
                cmd.Parameters.AddWithValue("@expiry", expiry);
                cmd.Parameters.AddWithValue("@type", type);
                cmd.ExecuteNonQuery();
                Console.WriteLine("Driver license added.");
            }
        }
    }

    static void Main()
    {
        TestConnection();
        int choice;
        do
        {
            Console.WriteLine("\n--- Car Insurance System ---");
            Console.Write("1. Register\n2. Sign in\n3. Exit\nChoice: ");
            choice = int.Parse(Console.ReadLine());

            if (choice == 1)
            {
                RegisterUser();
            }
            else if (choice == 2)
            {
                if (SignIn())
                {
                    int opt;
                    do
                    {
                        Console.WriteLine("\n--- Menu ---");
                        Console.WriteLine("1. Add Customer");
                        Console.WriteLine("2. Add Car");
                        Console.WriteLine("3. Add Accident");
                        Console.WriteLine("4. Add Insurance Policy");
                        Console.WriteLine("5. Add Monthly Report");
                        Console.WriteLine("6. Add Driver License");
                        Console.WriteLine("7. Delete Customer");
                        Console.WriteLine("8. Update Customer");
                        Console.WriteLine("9. Delete Car");
                        Console.WriteLine("10. Update Car");
                        Console.WriteLine("11. Update Accident");
                        Console.WriteLine("12. View Accidents");
                        Console.WriteLine("13. Generate Monthly Accident Report");
                        Console.WriteLine("14. Logout");
                        Console.Write("Choice: ");
                        opt = int.Parse(Console.ReadLine());

                        switch (opt)
                        {
                            case 1: AddCustomer(); break;
                            case 2: AddCar(); break;
                            case 3: AddAccident(); break;
                            case 4: AddInsurancePolicy(); break;
                            case 5: AddMonthlyReport(); break;
                            case 6: AddDriverLicense(); break;
                            case 7: DeleteCustomer(); break;
                            case 8: UpdateCustomer(); break;
                            case 9: DeleteCar(); break;
                            case 10: UpdateCar(); break;
                            case 11: UpdateAccident(); break;
                            case 12: ViewAccidents(); break;
                            case 13: GenerateMonthlyReport(); break;
                        }
                    } while (opt != 14);
                }
            }
        } while (choice != 3);
    }
}
