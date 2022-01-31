SELECT * FROM employee_db.employee_details;

-- Insert a user or group of users to be retrieve by the SELECT database connector within Mule application and MySQL
Insert into employee_details( `name_employee`, `email_employee`, `status_employee`)
Values ('Sam', 'example_sam@example.com', 'Active');
Insert into employee_db.employee_details( `name_employee`, `email_employee`, `status_employee`)
Values ( 'Lalo', 'example_lalo@example.com', 'Active');
Insert into employee_db.employee_details( `name_employee`, `email_employee`, `status_employee`)
Values ( 'Robert', 'example_robert@example.com', 'Active');
Insert into employee_db.employee_details( `name_employee`, `email_employee`, `status_employee`)
Values ( 'John', 'example_jonh@example.com', 'Active');
-- 'id_employee' can be supressed as is set to primary column and also set to autoincrement
-----

-- Creation of a test user to use at the configuration XML for Mule application before pushing to github
CREATE USER 'test'@'localhost' IDENTIFIED BY 'newpassword';
-- Grant access to our new user for all operations with "SELECT"
GRANT SELECT ON * . * TO 'test'@'localhost';
-- Grant access to our new user for all operations with "DELETE"
GRANT DELETE ON * . * TO 'test'@'localhost';
