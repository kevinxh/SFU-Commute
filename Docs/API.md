# SFU-Commute Backend REST API Documentation

## **1. Authentication**
----
### **Sign In**

  Authenticates user. Returns access_token and JSON data about the user.

* **URL**

  /auth/signin

* **Method:**

  `POST`

*  **URL Params**

   None

* **Data Params**

  **Required:**

  `email`: string

  `password`: string

* **Success Response:**

  * **Code:** 200 SUCCESS<br />
    **Content:**

    ```javascript
    {
      success : true,
      user : {...userobject...} ,
      access_token: "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImtAZ21haWwuY29tIiwiaWF0IjoxNDYzOTQ5MTgyLCJleHAiOjE0NjkxMzMxODJ9.TzgrUPJ64qXufZpLJ8YIyAIUSPMmohH2gOZLas-knzc",
    }
    ```

* **Error Response:**

  * **Code:** 400 BAD REQUEST <br />
    **Content:** `{ success: false, msg: "Please enter your email and password." }`

  OR

  * **Code:** 401 UNAUTHORIZED <br />
    **Content:** `{ success: false, msg: "Authentication failed. User not found." }`

  OR

  * **Code:** 401 UNAUTHORIZED <br />
    **Content:** `{ success: false, msg: "Authentication failed. Passwords did not match." }`

  OR

  * **Code:** 403 FORBIDDEN <br />
    **Content:** `{ success: false, msg: _mongodb query error_ }` <br />
    **Note**: Such as unique email and password length errors.


* **Sample Call: (unvarified in swift)**

  ```swift
  let parameters: Parameters = ["email": "kevin@gmail.com", "password": "password"]
  Alamofire.request("\(domain_root)/auth/signin", parameters: parameters, method: .post)
  ```


### **Sign Up**

  Sign up new user. Returns access_token and JSON data about the new user.

  * **URL**

    /auth/signup

  * **Method:**

    `POST`

  *  **URL Params**

     None

  * **Data Params**

    **Required:**

    `email`: string

    `password`: string

  * **Success Response:**

    * **Code:** 201 CREATED<br />
      **Content:**

      ```javascript
      {
        success : true,
        user : {...userobject...},
        access_token: "JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImtAZ21haWwuY29tIiwiaWF0IjoxNDYzOTQ5MTgyLCJleHAiOjE0NjkxMzMxODJ9.TzgrUPJ64qXufZpLJ8YIyAIUSPMmohH2gOZLas-knzc",
      }
      ```

  * **Error Response:**

    * **Code:** 400 BAD REQUEST <br />
      **Content:** `{ success: false, msg: "Please enter your email and password." }`

    OR

    * **Code:** 403 FORBIDDEN <br />
      **Content:** `{ success: false, msg: _mongodb query error_ }` <br />
      **Note**: Such as unique email and password length errors.


  * **Sample Call: (unvarified in swift)**

    ```swift
    let parameters: Parameters = ["email": "kevin@gmail.com", "password": "password"]
    Alamofire.request("\(domain_root)/auth/signup", parameters: parameters, method: .post)
    ```
