Feature: Wiki Link
  Background:
    Given There is a wiki space named "trainers"
    Given "Craig" is a user
    And I log in as user Craig

  Scenario Outline: 指定のWiki Linksが正しく動作する
    Given I visit "/wiki/trainers/wiki/Path/To/My/Page"
    When I edited the page with context "<wiki_link>"
    Then I should see a link "<text>" to "/wiki/trainers/wiki/<url>"
    Examples:
      | wiki_link   | text        | url     |
      #--------------------------------------
      | [[a]]       | a           | a       |
      | [[a b]]     | a b         | a%20b   |
      | [[a\|b]]    | b           |  a      |
      | [[\|b]]     | \|b         | %7Cb    |
      | [[a\|]]     | a\|         | a%7C    |
      | [[a#b]]     | a#b         | a%23b   |
      | [[a#b\|c]]  | c           | a%23b   |
      | [[a:b]]     | b           | a/b     |
      | [[a\\\|b]]  | a\|b        | a%7Cb   |
      | [[a (b)\|]] | a           | a%20(b) |
  
  Scenario Outline: リンクの直前直後のテキストは取り込まれない
    Given I visit "/wiki/trainers/wiki/Path/To/My/Page"
    When I edited the page with context "<wiki_link>"
    Then I should see a link "<link_label>" to "/wiki/trainers/wiki/<url>"
    And "<text>"というテキストが存在する
    Examples:
      | wiki_link   | link_label  | text | url   |
      #-------------------------------------------
      | a[[b]]      | b           | ab   | b     |
      | [[a]]b      | a           | ab   | a     |
      | [[[[A]]]]   | A           | [[A]]| A     |

  Scenario: <nowiki>[[a]]</nowiki> でリンクが生成されない
    Given I visit "/wiki/trainers/wiki/Path/To/My/Page"
    When I edited the page with
      | title  | body                                 |
      | a page | see a link to <nowiki>[[a]]</nowiki> |
    Then I should not see a link "a" to "/wiki/trainers/wiki/a"
    And "[[a]]"というテキストが存在する
