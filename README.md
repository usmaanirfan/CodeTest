# CodeTest - Assignment 
## An iOS(iPhone/iPad)  app to show Locations weather. Built in Swift using Xcode 12.4


## New Feature 1 - Add location
On tap of  right navigation bar button user is presented with location deatail to be entered eq: Location name, Weather and temprature. After click on 'Done' location is added.

## New Feature 2 - Delete location
When user swipe right to left any cell on first screen then user is presented with delete button. That user can tap to remove any location out of the list.

## Description
This app is being developed using Protocol oriented approach. This App contains two screens. First screen shows the list of weather and options to add and delete weather. 

App has  module to show location list, Network  and Common module as a helper. Location list module contains view controller, controller(presenter). Application business logic resides into controller(presenter) while UI logic resides into view controller.

## Dependency
There is no third party API dependency.


## Getting Started
Clone this repo to your hard drive using 'git clone https://github.com/usmaanirfan/CodeTest.git'. Open 'CodeTest.xcodeproj' in Xcode.

## Testing
The tests can be run in Xcode by pressing Cmd + U after selecting Test target ShowPlacesTests.
There are currently unit tests, using some mock classed and json files.

## Tools used
Xcode 12.4 , Simulator(iPhone 11/iPad) iOS 14 and iOS 14 (iPhone 7)


