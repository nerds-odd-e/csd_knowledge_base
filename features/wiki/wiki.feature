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
      | a page | see a link to [[another]] |
    Then I should see a link "another" to "/wiki/trainers/wiki/another"

  Scenario: スペースつきのリンクが作成されている
    Given I visit "/wiki/trainers/wiki/Path/To/My/Page"
    When I edited the page with
      | title  | body                           |
      | a page | see a link to [[another page]] |
    Then I should see a link "another page" to "/wiki/trainers/wiki/another%20page"
  
  #@wip
  Scenario Outline: Wiki Link
    Given I visit "/wiki/trainers/wiki/Path/To/My/Page"
    When I edited the page with context "<WikiLink>"
    Then I should see a link "<text>" to url "/wiki/trainers/wiki/<url>"
    Examples:
      | WikiLink    | text        | url   |
      #------------------------------------
      | [[a]]      | a           | a     |
      | [[a b]]     | a b         | a%20b   |
      | [[a\|b]]    | b           | a     |
      # | [[a#b]]     | a#b         | a#b   |
      # | [[a#b\|c]]  | c           | a#b   |
      # | [[a:b]]     | b           | a/b   |
      # | [[a\\\|b]]  | a\|b        | a%7Cb |
      # | [[a (b)\|]] | a           | a (b) |
      # | [[[[A]]]]   | [[A]]       | A     |

  @wip
  Scenario: セクションつきのリンクも設定できる
    Given I visit "/wiki/trainers/wiki/Path/To/My/Page"
    When I edited the page with
      | title  | body                           |
      | a page | see a link to [[page#section]] |
    Then I should see a link "page#section" to "/wiki/trainers/wiki/page#section"

  @wip
  Scenario: リンク先に別の表示名を設定できる（セクション付き）
    Given I visit "/wiki/trainers/wiki/Path/To/My/Page"
    When I edited the page with
      | title   | body                                |
      | a page1 | see a link to [[page#section\|name]] |
    Then I should see a link "name" to "/wiki/trainers/wiki/page#section"

 
  Scenario: リンク先に別の表示名を設定できる(シンプル)
    Given I visit "/wiki/trainers/wiki/Path/To/My/Page"
    When I edited the page with
      | title   | body                                |
      | a page1 | see a link to [[page\|name]] |
    Then I should see a link "name" to "/wiki/trainers/wiki/page"

  Scenario: リンク先に別の表示名を設定できる（前パイプ）
    Given I visit "/wiki/trainers/wiki/Path/To/My/Page"
    When I edited the page with
      | title   | body                                |
      | a page1 | see a link to [[\|name]] |
    Then I should see a link "|name" to "/wiki/trainers/wiki/%7Cname"

  Scenario: リンク先に別の表示名を設定できる（後パイプ）
    Given I visit "/wiki/trainers/wiki/Path/To/My/Page"
    When I edited the page with
      | title   | body                                |
      | a page1 | see a link to [[link\|]] |
    Then I should see a link "link|" to "/wiki/trainers/wiki/link%7C"

  @wip
  Scenario: エスケープされた特殊文字を表示名として設定できる
    Given I visit "/wiki/trainers/wiki/Path/To/My/Page"
    When I edited the page with
      | title  | body                           |
      | a page | see a link to [[page\\\|name]] |
    Then I should see a link "page|name" to "/wiki/trainers/wiki/page|name"

  @wip
  Scenario: パイプを使用して半角括弧を除いた文字を表示する
    Given I visit "/wiki/trainers/wiki/Path/To/My/Page"
    When I edited the page with
      | title  | body                           |
      | a page | see a link to [[page (sub)\|]] |
    Then I should see a link "page" to "/wiki/trainers/wiki/page%20(sub)"

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
