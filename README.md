# Mule application to fetch from a MySQL database to build a REST web service 
- This web service allows to access over HTTP GET method to retrieve data from a MySQL database using Mule tools like Anypoint Studio as the IDE, Mule runtime to host the server and ARDC-Advanced REST Client or Chrome to visualize graphically the HTTP response either from the **header** or **body**.
- Upon retrievement from database, requieres a transfromation from java object to a friendly format such as JSON - Java Script Object Notation using REST- Representational State Transfer as the standard for modern development of  API - Application Programming Interface. 

- *URLs for the web service:*
    - GET all employees :`http://localhost:8091/emp-sapi/get-employee`
    - GET employee with queryParameter: `http://localhost:8091/emp-sapi/get-employee?employeeID=100`
- HTTP response header: ``200, OK``
- HTTP response body to GET all employees:
    ```json
    
    ```
- HTTP response body to GET one employee through it's Identification number:
    ```json
    
    ```