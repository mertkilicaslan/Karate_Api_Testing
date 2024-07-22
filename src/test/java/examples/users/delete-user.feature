Feature: ReqRes API Tests for deleting user

  Background:
    * url 'https://reqres.in'
    * configure headers = { "Content-Type": "application/json" }

  Scenario: Delete user with ID 2
    Given path 'api/users/2'
    When method DELETE
    Then status 204
    And match response == ''