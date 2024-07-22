Feature: ReqRes API Tests for create a user

  Background:
    * url 'https://reqres.in'
    * configure headers = { "Content-Type": "application/json" }

  Scenario: Create a new user
    Given path 'api/users'
    And request { "name": "morpheus", "job": "leader" }
    When method POST
    Then status 201
    And match response.name == 'morpheus'
    And match response.job == 'leader'
    And match response.id != null
    And match response.createdAt != null

  Scenario: Validate response schema
    Given path 'api/users'
    And request { "name": "morpheus", "job": "leader" }
    When method POST
    Then status 201
    And match response == { name: '#string', job: '#string', id: '#string', createdAt: '#string' }

  Scenario: Create a user without a name field
    Given path 'api/users'
    And request { "job": "leader" }
    When method POST
    Then status 201
    And match response.name == '#notpresent'

  Scenario: Create a user without a job field
    Given path 'api/users'
    And request { "name": "morpheus"}
    When method POST
    Then status 201
    And assert !response.job

  Scenario: Create multiple users
    * def users = [{ "name": "morpheus", "job": "leader" }, { "name": "trinity", "job": "hacker" }]
    Given path 'api/users'
    And request users[0]
    When method POST
    Then status 201
    And match response.name == users[0].name
    And match response.job == users[0].job
    And match response.id != null
    And match response.createdAt != null

    Given path 'api/users'
    And request users[1]
    When method POST
    Then status 201
    And match response.name == users[1].name
    And match response.job == users[1].job
    And match response.id != null
    And match response.createdAt != null

  Scenario: Create user with NaN name
    Given path 'api/users'
    And def NaN_name = 'a' * 256
    And request { "name": "#(NaN_name)", "job": "leader" }
    When method POST
    Then status 400
    And match response contains 'Bad Request'

  Scenario: Create user with special characters in name
    Given path 'api/users'
    And request { "name": "mor$#@!", "job": "leader" }
    When method POST
    Then status 201
    And match response.name == 'mor$#@!'
    And match response.job == 'leader'
    And match response.id != null
    And match response.createdAt != null

  Scenario: Create user and verify headers
    Given path 'api/users'
    And request { "name": "morpheus", "job": "leader" }
    When method POST
    Then status 201
    And match responseHeaders['Content-Type'][0] == 'application/json; charset=utf-8'
