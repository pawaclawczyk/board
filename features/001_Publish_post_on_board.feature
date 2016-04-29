Feature: Publish post on board

  Scenario: Publish post on board
    Given board named "My Board"
     When publish post on board "My Board" with content "Hello everyone!"
     Then post should be publish on board "My Board" with content "Hello everyone!"
