Feature: Sample API Tests

  Background:
    * url 'https://reqres.in/api'
    * header Accept = 'application/json'

  # Simple Get Request
  Scenario: GET Demo 1
    Given path '/users'
    And param page = 2
    When method GET
    Then status 200

    # Using match to validate the exact value
    And match response.per_page == 6

    # Using assert to validate the condition (boolean)
    And assert response.per_page == 6

     # $ sign can be an alias for response
    And match $.data.length != 0



    * print response
    * print responseStatus
    * print responseTime
    * print responseHeaders
    * print responseCookies


    