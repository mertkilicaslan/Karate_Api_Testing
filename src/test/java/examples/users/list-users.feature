Feature: ReqRes API Test for List Users

  Background:
    * url 'https://reqres.in'
    * configure headers = { "Content-Type": "application/json" }

  Scenario: Verify users list on page 2
    Given path 'api/users'
    And param page = 2
    When method GET
    Then status 200
    And match response.page == 2
    And match response.per_page == 6
    And match response.total == 12
    And match response.total_pages == 2
    And match response.data ==
    """
      [
        { id: 7, email: 'michael.lawson@reqres.in', first_name: 'Michael', last_name: 'Lawson', avatar: 'https://reqres.in/img/faces/7-image.jpg' },
        { id: 8, email: 'lindsay.ferguson@reqres.in', first_name: 'Lindsay', last_name: 'Ferguson', avatar: 'https://reqres.in/img/faces/8-image.jpg' },
        { id: 9, email: 'tobias.funke@reqres.in', first_name: 'Tobias', last_name: 'Funke', avatar: 'https://reqres.in/img/faces/9-image.jpg' },
        { id: 10, email: 'byron.fields@reqres.in', first_name: 'Byron', last_name: 'Fields', avatar: 'https://reqres.in/img/faces/10-image.jpg' },
        { id: 11, email: 'george.edwards@reqres.in', first_name: 'George', last_name: 'Edwards', avatar: 'https://reqres.in/img/faces/11-image.jpg' },
        { id: 12, email: 'rachel.howell@reqres.in', first_name: 'Rachel', last_name: 'Howell', avatar: 'https://reqres.in/img/faces/12-image.jpg' }
      ]
  """
    And match response.support.url == 'https://reqres.in/#support-heading'
    And match response.support.text == 'To keep ReqRes free, contributions towards server costs are appreciated!'

  Scenario: Verify response time is acceptable
    Given path 'api/users'
    And param page = 2
    When method GET
    Then status 200
    And assert responseTime < 2000

  Scenario: Validate the structure of the response
    Given path 'api/users'
    And param page = 2
    When method GET
    Then status 200
    And match response contains { "page": 2, "per_page": "#number", "total": "#number", "total_pages": "#number", "data": "#[]", "support": "#object" }
    And match each response.data[*].id == '#number'
    And match each response.data[*].email == '#string'
    And match each response.data[*].first_name == '#string'
    And match each response.data[*].last_name == '#string'
    And match each response.data[*].avatar == '#string'

  Scenario: Check if specific user data exists
    Given path 'api/users'
    And param page = 2
    When method GET
    Then status 200
    And match response.data contains { "id": 8, "email": "lindsay.ferguson@reqres.in", "first_name": "Lindsay", "last_name": "Ferguson", "avatar": "https://reqres.in/img/faces/8-image.jpg" }

  Scenario: Verify data types of the response
    Given path 'api/users'
    And param page = 2
    When method GET
    Then status 200
    And match response.page == 2
    And match response.per_page == '#number'
    And match response.total == '#number'
    And match response.total_pages == '#number'
    And match response.data == '#[]'
    And match each response.data == { id: '#number', email: '#string', first_name: '#string', last_name: '#string', avatar: '#string' }
    And match response.support == { url: '#string', text: '#string' }

  Scenario: Validate user avatars are URLs
    Given path 'api/users'
    And param page = 2
    When method GET
    Then status 200
    And match each response.data[*].avatar contains 'https://reqres.in/img/faces/'

  Scenario: Ensure no duplicate user IDs
    Given path 'api/users'
    And param page = 2
    When method GET
    Then status 200
    # $ symbol is used to refer to the root of the JSON response
    * def userIds = $.data[*].id
    * def uniqueUserIds = karate.distinct(userIds)
    And assert userIds.length == uniqueUserIds.length

