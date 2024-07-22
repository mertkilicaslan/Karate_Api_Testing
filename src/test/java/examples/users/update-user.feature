Feature: ReqRes API Tests for updating a user

  Background:
    * url 'https://reqres.in'
    * configure headers = { "Content-Type": "application/json" }

  Scenario: Update user with PUT method
    Given path 'api/users/2'
    And request { "name": "morpheus", "job": "zion resident" }
    When method PUT
    Then status 200
    And match response.name == 'morpheus'
    And match response.job == 'zion resident'
    And match response.updatedAt != null

  Scenario: Validate response schema for PUT method
    Given path 'api/users/2'
    And request { "name": "morpheus", "job": "zion resident" }
    When method PUT
    Then status 200
    And match response == { name: '#string', job: '#string', updatedAt: '#string' }

  Scenario: Missing job field in PUT request
    Given path 'api/users/2'
    And request { "name": "morpheus" }
    When method PUT
    Then status 200
    And match response.job == '#notpresent'

  Scenario: Empty name value in PUT request
    Given path 'api/users/2'
    And request { "name": "", "job": "zion resident" }
    When method PUT
    Then status 200
    And match response.name == ''

  Scenario: Update user with PATCH method
    Given path 'api/users/2'
    And request { "job": "zion resident" }
    When method PATCH
    Then status 200
    And match response.job == 'zion resident'
    And match response.updatedAt != null

  Scenario: Validate response schema for PATCH method
    Given path 'api/users/2'
    And request { "job": "zion resident" }
    When method PATCH
    Then status 200
    And match response == { job: '#string', updatedAt: '#string' }

  Scenario: Missing fields in PATCH request
    Given path 'api/users/2'
    And request { }
    When method PATCH
    Then status 200
    And assert !response.name && !response.job

  Scenario: Empty job and none present name in PATCH request
    Given path 'api/users/2'
    And request { "job": "" }
    When method PATCH
    Then status 200
    And match response.job == ''
    And match response.name == '#notpresent'

  Scenario: Update user with special characters in name using PUT
    Given path 'api/users/2'
    And request { "name": "mor$#@!", "job": "zion resident" }
    When method PUT
    Then status 200
    And match response.name == 'mor$#@!'
    And match response.job == 'zion resident'
    And match response.updatedAt != null

  Scenario: Update user and verify headers with PUT
    Given path 'api/users/2'
    And request { "name": "morpheus", "job": "zion resident" }
    When method PUT
    Then status 200
    And match responseHeaders['Content-Type'][0] == 'application/json; charset=utf-8'

  Scenario: Update user with numeric job title using PATCH
    Given path 'api/users/2'
    And request { "job": 123 }
    When method PATCH
    Then status 200
    And match response.job == '#number'
    And assert response.job == 123

