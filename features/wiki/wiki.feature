Feature: Trainer's Wiki
  Background:
    Given There is a wiki space named "trainers"
    Given "Craig" is a user
    And "Terry" is a user
    And I log in as user Craig

  Scenario: Create a new WikiPage
    Given I visit "/wiki/trainers/wiki/Path/To/My/Page"
    When I edited the page with
      | title         | body             |
      | my first page | something useful |
    And I should see the wiki page containing
      | title         | body             | revision | revision-date |
      | my first page | something useful | Craig   | On:    |

  Scenario: Edit an existing WikiPage
    Given there is a wiki page with path "my_page" by user Terry
    When I visit "/wiki/trainers/wiki/my_page"
    And I should see the wiki page containing
      | revision  |
      | Terry |
    And I click Edit This Wiki Page
    When I edited the page with
      | title         | body             |
      | my first page | something useful |
    Then I should see the wiki page containing
      | title         | body             | revision | revision |
      | my first page | something useful | Craig    | Terry    |

  Scenario: WikiPage with link navigating within the wiki
    Given I visit "/wiki/trainers/wiki/Path/To/My/Page"
    When I edited the page with
      | title  | body                           |
      | a page | see a link to [[another page]] |
    Then I should see a link "another page" to "/wiki/trainers/wiki/another%20page"
