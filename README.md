# Key Server

This is a simple key server implementation using Sinatra. The requirements are defined in [Requirements.md](Requirements.md) File.

## Setup

1. Install Ruby and Ruby Gems on your system. Ruby version > 2.6.6 , Gem version 3.2.3
2. Clone or download the Key Server code from the repository.
3. Open a terminal or command prompt and navigate to the directory containing the Key Server code.
4. Make sure you have the required dependencies installed by running the following command:
    ```
    gem install bundler
    bundle install
    ```

## Usage
1. Start the server by running the following command:
    ```
    ruby controller.rb
    ```
2. The server will be accessible at http://localhost:4567.

## Endpoints

### Generate a Key
* URL: /keys
* Method: POST
* Response Code: 201 Created
* Response Body: JSON object with the generated key.

### Get an Available Key
* URL: /keys/available
* Method: GET
* Response Code: 200 OK
* Response Body: JSON object with an available key.

### Unblock a Key
* URL: /keys/:key/unblock
* Method: PATCH
* Response Code: 200 OK if the key is unblocked, 404 Not Found otherwise.
* Response Body: JSON object with a success message if the key is unblocked, or an error message if the key is not found or not blocked.

### Delete a Key
* URL: /keys/:key
* Method: DELETE
* Response Code: 200 OK if the key is deleted, 404 Not Found otherwise.
* Response Body: JSON object with a success message if the key is deleted, or an error message if the key is not found.

### Keep Alive
* URL: /keys/:key/keep_alive
* Method: PUT
* Response Code: 200 OK if the key's expiry time is updated, 404 Not Found otherwise.
* Response Body: JSON object with a success message if the key's expiry time is updated, or an error message if the key is not found.

## Testing
To run the tests, execute the following command:

```
rspec spec_*
```
