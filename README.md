# Mule application to fetch from a MySQL database to build a REST web service 

## GET all employees & GET employee by ID using Query Parameters 
- This web service allows to access over HTTP GET method to retrieve data from a MySQL database using Mule tools like Anypoint Studio as the IDE, Mule runtime to host the server and ARDC-Advanced REST Client or Chrome to visualize graphically the HTTP response either from the **header** or **body**.
- Upon retrievement from database, requieres a transfromation from java object to a friendly format such as JSON - Java Script Object Notation using REST- Representational State Transfer as the standard for modern development of  API - Application Programming Interface. 

- *URLs for the web service:*
    - GET all employees :`http://localhost:8091/emp-sapi/get-employees`
    - GET employee with queryParameter: `http://localhost:8091/emp-sapi/get-employee?employeeID=100`
- HTTP response header: ``200, OK``
- HTTP response body to GET all employees:
    ```json     
    [
        {
            "id_employee": 1,
            "email_employee": "example_sam@example.com",
            "status_employee": "Active",
            "name_employee": "Sam"
        }
    ]
    ```
- HTTP response body to GET one employee through it's Identification number:
    ```json           
    [
        {
            "id_employee": 1,
            "email_employee": "example_sam@example.com",
            "status_employee": "Active",
            "name_employee": "Sam"
        }
    ]    
    ```
- The sql file for the creation of database and table can be found at `./database/creation_employee_db.sql`
- Within the same directory `./database/query&test_user.sql` can be found a query `sql` file to configure our database with a new user and granted access for `SELECT` operations only over the `employee_details` table.
    - Contains the following operations:
    ```sql
    SELECT * FROM employee_db.employee_details;

    -- Creation of a test user to use at the configuration XML for Mule application before pushing to github
    CREATE USER 'test'@'localhost' IDENTIFIED BY 'newpassword';
    -- Grant access to our new user for all operations with "SELECT"
    GRANT SELECT ON * . * TO 'test'@'localhost';
    ```
    - This `test` user and `password` has to be set at `./src/main/mule/rest-serice-fetch-from-mysql-db.xml`, which is the *configuration XML file* for the Mule application at the `<db:my-sql-connection>` within `<db:config>` elements of both *GET -all employees* and *GET - employee by ID* using query Parameters.  

    ## Analyzing the XML configuration file from the Mule Application
    - All modules and connectors can e found within Anypoint Studio IDE at the Mule Palette:
        ![](https://dz2cdn1.dzone.com/storage/temp/7998541-anypoint2.png)*Anypoint Studio Mule Pallette for connectors and modules*
    1. A Listener connector from the HTTP module will be use to stablish the base path and the secundary path for the for the connection between server and client:
        ```xml
        <http:listener-config name="HTTP_Listener_config" doc:name="HTTP Listener config" doc:id="df00c62c-4549-4fe0-a0cd-9b98f6198488" basePath="emp_sapi" >
            <http:listener-connection host="0.0.0.0" port="8081" />
        </http:listener-config>
        ```
        - `basePath` attribute from the `<http:listener-config>` tag is used to set the base path of the URL used for querying by a REST client, example: `http://localhost:8091/emp-sapi/`, where `emp_sapi` is the base path.
    2. As a trigger for our Mule application, will be use a ``SELECT`` connector from the *database* module, this  will be retrieving data from the database `employee_db` where `employee_details` is the table containing the following columns including sample data:

        | id_employee | name_employee | email_employee | status_employee|
        | --- | --- | --- | --- |
        | 1 | Sam | example_sam@example.com | Active |  

        ```xml
        <db:select doc:name="Select" doc:id="fc101ccd-9e0c-460e-9871-51ac2f6969f4" config-ref="Database_Config">
            <db:sql ><![CDATA[SELECT * FROM employee_details WHERE id_employee= :ID]]></db:sql>
            <db:input-parameters ><![CDATA[#[ID: attributes.queryParams.employeeID]]]></db:input-parameters>
        </db:select>
        ```
        - `<dv:select>` is the connector from the Database module where one of its attribute `config-ref="Database_Config"` uses the following metadata to connect to database:
            - MySQL JDBC Driver 
            ```
            host: localhost
            port: 3306
            user: test (defined on the sql file ./database/query&test_user.sql)
            Password: test
            database: employee_db
            ```
            - Inside of `<db:select>` there are 2 XML tags:
                - `<db:sql>`: Is where the SQL commands will be written, uses a special syntax for adding a variable called `ID` which will later be taken by the *Input parameters* section.
                - `<db:input-parameters>`: defines a dynamic value for the SQL query to database taking in consideration in this case of the query Parameters found at the URL using Dataweave 2.0 transformation language.

    3. In order to set a RESTful response, a transformation of data retrieved by the *Select* connector is needed by using a *Transform Message* connector, which will parse the input released by the *Select* connector as a Plain Old Java Object to the out we want to consume by the frontend as a JSON - JavaScript Object Notation.
        - *Transform Message* uses *DataWeave 2.0* transformation language as a way to parse many different data type formats back and fordward, for this example will transform Java linkedHashMap to a JSON.

            ```xml
            <ee:transform doc:name="Transform Message" doc:id="8c211c2e-f9ff-43d1-8275-cd02ffc7f4e9" >
                <ee:message >
                    <ee:set-payload ><![CDATA[%dw 2.0
                        output application/json
                        ---
                        payload map ( payload01 , indexOfPayload01 ) -> {
                            employeeID: payload01.id_employee,
                            employeeName: payload01.name_employee default "",
                            employeeStatus: payload01.email_employee default "",
                            employeeEmail: payload01.status_employee default ""
                        }]]></ee:set-payload>
                </ee:message>
            </ee:transform>
            ```

            - `<ee:transform>` xml tag is the connector for the Transform Message, within 2 more tags are used:
                - `<ee:message>` contains the payload or the data to be transformed 
                    - `<ee:set-payload>` it defines the internal structure to be set for the new payload, the result will be the output achieve at the response body for the REST client.
                        - It includes at the head, type of data for the application, this could be json, csv, xml, java and many other types
                        - ``payload`` contains all data from the input, combine with the ``map`` built in function, sets a new payload with an specific payload to output.
                        - `map` uses 3 parameters, the array-object, element of the array, index the element within the array.

-----
## DELETE an employee record from the table wih REST operations
This part includes:
- Read of URI-Uniform Resource Identifier from the mule event.
- Delete operation for the records based on URI Params delete an employee from `employee_details` found at `employeedb`.   
- *URL for the web service:*
    - http://localhost:8091/emp-sapi/delete-employee/101/John
- HTTP response header: 200 OK.
- HTTP response body:
    ```json
    {
        "status": 200,
        "message": "Success"
    }
    ```
- Grant access for `test` user of the database to all ``DELETE`` operations:
    ```sql
    GRANT DELETE ON * . * TO 'test'@'localhost';
    ```
    ## Analyzing the XML configuration file from the Mule Application
    It requieres at least 3 connectors for the flow, HTTP listener (mule event source), Delete (mule event processor) and Transform Message (mule event processor).

    ````xml
    <http:listener doc:name="Listener" doc:id="271604e2-4198-452d-97ea-f6f0102ce5c8" config-ref="HTTP_Listener_config" path="delete-employee/{ID}/{NAME}" allowedMethods="DELETE"/>
    ````
    1. ``<http:listener-config>`` contains  several attributes such as `path` and `allowedMethods`
        - `allowedMethods` describes the CRUD- Create Read Update Delete type of operation, which is not set to auto, instead is configure to "DELETE"
        - `path="delete-employee/{ID}/{NAME}"` contains the URI Parameteres separated with an slash `/` afyer the sub path which is `delete-employee`, to access `{ID}` and `{NAME}` on Dataweave is using squared brackets as an array:
        ```js
        attributes.uriParams[0] //=> for the first element which is {ID}
        attributes.uriParams[1] //=> for the second element which is {NAME}
        ```
    ----
    ```xml
        <db:delete doc:name="Delete" doc:id="40e3034b-5ed6-4932-a8b7-50f44da45cb1" config-ref="Database_Config">
                <db:sql ><![CDATA[DELETE FROM employee_details
                       WHERE id_employee = :ID AND name_employee = :NAME]]></db:sql>
                <db:input-parameters ><![CDATA[#[{
                    ID: attributes.uriParams[0],
                    NAME: attributes.uriParams[1]
                }]]]></db:input-parameters>
        </db:delete>
    ```
    2.  `<db:delete>` XML tag is the *Delete* processor for the *Database* module, uses several attributes in which `config-ref="Database_Config"` refers to the following configuration:
    ```
    host: localhost
    port: 3306
    user: test
    password: ***
    database: employee_db
    ```
    - `<db:sql>` between tags references to the SQL statement for the *Delete* operation, this one uses some variables like `ID` and `NAME` that serves as placeholders for the input URI Parameters from the URL.
        - `<db:input-parameters>` uses DataWeave 2.0 language to access the Mule event and retrieved metadata input by the client such as `id_emloyee` & `name_employee` that is needed to complete the SQL *Delete* operation.
    ---
    ```xml
    <ee:transform doc:name="Transform Message" doc:id="32914a29-c82f-400b-9716-7a4c04ea906b" >
        <ee:message >
            <ee:set-payload ><![CDATA[%dw 2.0
            output application/json
            ---
            {
                "status": 200,
                "message": "Success"
            }]]></ee:set-payload>
        </ee:message>
    </ee:transform>
    ```
    3. `<ee:transform>` XML tag contains the response body for the client.
        - `<ee:message>` contains the mule event, it contains the metadata as well as data
            - `<ee:set-payload>` here we can find dataweave definition for the payload or response body for the client, a generic JSON format message is the outpu REST client will receive.
