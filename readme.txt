ChildPuzzle is a personal demo game written in Swift for the iPads.


Gameplay:
---------
The child starts to play on a stage, which shows a nice background. Some parts of the 
background (matching items) are cut off and they are floating around somewhere on the scene. 
The goal is to find and place all these items to their appropriate position using drag 
and drop.

There is also a possibility to change difficulty level. If the player chooses to play
on easy or medium, some of the items will be already placed to winner position.

Some (not-really-)hidden elements are also placed over the background, which are 
considered as miracle items. After tapping these, they are doing some animations and/or
triggering sound effects.
For example on stage 2 there is a frog placed, which plays a frog sound when tapped.

Two types of these are existing:
  1. forever types: after performing their miracles, they are remaining on the scene to 
     play with them again
  2. one-time types: after performing their miracles, they will no longer be the part of 
     that game

After the player won, depending on the Auto-play settings, the game will start the next 
stage, or navigates back to the menu system when the feature is turned off.


About the Beta version:
-----------------------
Since it is a learning project, not all fancy features of Swift is used yet, but the code 
is Swift 3 ready.

Features and used technologies in the game:

- works and looks like the same on all iPads
- a custom MVC-like application ecosystem is created and used, 
  which can be used as a base for other games like this
- used Storyboard to create the menu system
- layout constraints are set-up, some of them are animated
- difficulty level can be changed
- an auto-play feature is implemented to let the child play 
  continuously without bothering with the menu system
- clearly documented code
- uses SpriteKit/UIKit for rendering and animations
- uses Particle system
- uses AVFoundation for music and effects handling
- uses SQLite.swift for database handling
- uses NSUserDefaults for storing application settings

Future releases are planned to include:

- usage of protocols and protocol extensions instead of subclassing whereever it fits
- usage of GamePlayKit
- pre-fetching all media which would allow a more seemless experience
- more miracle items
- a dynamic stage selection scene. Right now the stage images on the buttons and the 
  actions they are triggering are hardcoded, this should be gone


Copyright of used media:
------------------------
All the used media content (images, sound effects, music) in the project are coming from 
the wild internet, and they are not about to be used in any commercial and non-commercial 
releases. All these media items are the property of their respective owners.  
