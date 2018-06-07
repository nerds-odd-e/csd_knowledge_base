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

  Scenario Outline: Wiki Link
    Given I visit "/wiki/trainers/wiki/Path/To/My/Page"
    When I edited the page with context "<WikiLink>"
    Then I should see a link "<text>" to "/wiki/trainers/wiki/<url>"
    Examples:
      | WikiLink    | text        | url   |
      #------------------------------------
      | [[a]]       | a           | a     |
      | [[a b]]     | a b         | a%20b |
      | [[a\|b]]    | b           |  a    |
      | [[\|b]]     | \|b         | %7Cb  |
      | [[a\|]]     | a\|         | a%7C  |
      | [[a#b]]     | a#b         | a%23b |
      | [[a#b\|c]]  | c           | a%23b |
      | [[a:b]]     | b           | a/b   |
      | [[a\\\|b]]  | a\|b        | a%7Cb |

  Scenario: リンクの直前にあるテキストは取り込まれない
    Given I visit "/wiki/trainers/wiki/Path/To/My/Page"
    When I edited the page with
      | title  | body                           |
      | a page | see a link to text[[page]] |
    Then I should see a link "page" to "/wiki/trainers/wiki/page"
    And "text"というテキストが存在する

  Scenario: リンクの直後にあるテキストは取り込まれない
    Given I visit "/wiki/trainers/wiki/Path/To/My/Page"
    When I edited the page with
      | title  | body                           |
      | a page | see a link to [[page]]text |
    Then I should see a link "page" to "/wiki/trainers/wiki/page"
    And "text"というテキストが存在する

  @wip
  Scenario: <nowiki>[[a]]</nowiki> でリンクが生成されない
    Given I visit "/wiki/trainers/wiki/Path/To/My/Page"
    When I edited the page with
      | title  | body                           |
      | a page | see a link to <nowiki>[[a]]</nowiki> |
    Then I should not see a link "a" to "/wiki/trainers/wiki/a"
    And "[[a]]"という文字がリンクではない

  @wip
  Scenario Outline: Wiki Link wip
    Given I visit "/wiki/trainers/wiki/Path/To/My/Page"
    When I edited the page with context "<WikiLink>"
    Then I should see a link "<text>" to "/wiki/trainers/wiki/<url>"
    Examples:
      | WikiLink    | text        | url   |
      #------------------------------------
      | [[a (b)\|]] | a           | a (b) |
      | [[[[A]]]]   | [[A]]       | A     |
