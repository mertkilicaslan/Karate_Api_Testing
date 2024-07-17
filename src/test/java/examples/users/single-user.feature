Feature: ReqRes API Test for Getting User with ID 2

  Background:
    * url 'https://reqres.in'
    * configure headers = { "Content-Type": "application/json" }

  Scenario: Get user with ID 2
    Given path 'api/users/2'
    When method GET
    Then status 200
    And match response ==
    """
    {
      "data": {
        "id": 2,
        "email": "janet.weaver@reqres.in",
        "first_name": "Janet",
        "last_name": "Weaver",
        "avatar": "https://reqres.in/img/faces/2-image.jpg"
      },
      "support": {
        "url": "https://reqres.in/#support-heading",
        "text": "To keep ReqRes free, contributions towards server costs are appreciated!"
      }
    }
    """

  Scenario: Validate response schema
    Given path 'api/users/2'
    When method GET
    Then status 200
    And match response == { data: '#object', support: '#object' }
    And match response.data == { id: '#number', email: '#string', first_name: '#string', last_name: '#string', avatar: '#string' }
    And match response.support == { url: '#string', text: '#string' }

  Scenario: Validate user email format
    Given path 'api/users/2'
    When method GET
    Then status 200
    And match response.data.email == '#string'
    And assert response.data.email.contains('@')
    And assert response.data.email.endsWith('reqres.in')

  Scenario: Check response contains support message
    Given path 'api/users/2'
    When method GET
    Then status 200
    And match response.support.text contains 'contributions towards server costs are appreciated'

  Scenario: Validate response time
    Given path 'api/users/2'
    When method GET
    Then status 200
    And assert responseTime < 2000

  Scenario: User not found
    Given path 'api/users/23'
    When method GET
    Then status 404

  Scenario: Validate avatar URL format
    Given path 'api/users/2'
    When method GET
    Then status 200
    And match response.data.avatar == 'https://reqres.in/img/faces/2-image.jpg'
    And assert response.data.avatar.startsWith('https://')

  Scenario: Validate response headers
    Given path 'api/users/2'
    When method GET
    Then status 200
    And match responseHeaders.Content-Type[0] == 'application/json; charset=utf-8'

  Scenario: Validate user ID type
    Given path 'api/users/2'
    When method GET
    Then status 200
    And assert typeof response.data.id == 'number' && response.data.id > 0

  Scenario: Simulate slow response (useful for timeouts testing)
    * configure connectTimeout = 5000
    * configure readTimeout = 5000
    Given path 'api/users/2'
    When method GET
    Then status 200

  Scenario: Check for unexpected fields in response
    Given path 'api/users/2'
    When method GET
    Then status 200
    And assert !response.data.unexpectedField
