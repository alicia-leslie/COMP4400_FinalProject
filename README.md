# COMP4400_FinalProject
Principles of Programming Languages Final Project in Prolog
This project was created using Prolog (GNU Prolog), which falls under the logical programming paradigm. The project is a terminal-based maze type game with interconnected locations, paths, and object relations. The goal of this project is for the user to enter the maze (in this case a house), navigate throughout the interconnected map, interact with objects connected via defined relationships all with the purpose of finding the required item and escaping. 

## How to Play
The main idea of this game is for a user to navigate through a maze to find and retrieve a specific item. The user plays the role of a detective looking for a priceless painting that was stolen from a museum many months ago. The user is notified that the painting might be hidden within the walls of an abandoned house, and thus, they must try their best to solve the clues to find the painting. The user must navigate throughout the map using the directional commands for north, south, east, and west, which are n., s., e., w. respectively. Additionally, the user has other directional commands for special locations, such as enter. and leave. for entering and exiting the house respectively, as well as u. and d. (up and down), for using the stairs. 

There are locations within the map that are considered to be dark. Thus, in order to see the contents and surroundings within these rooms, the user must find specific items (a flashlight and battery), to illuminate the location. Additionally, there are rooms which are considered locked, and in order to enter them, the user must find specific items (such as keys), to unlock said locations. 

As mentioned before, the user must utilize various objects to solve the maze and find the winning item. These items are located across the map in various rooms. The items located in dark rooms are considered invisible to the user until the user utilizes items that illuminate rooms. Additionally, there are certain items which can be opened to reveal other items inside of them (such as a fridge). The user can take items, inspect them once they are in their inventory, and then use them to solve certain puzzles. Some items cannot be taken by the user (due to them being too heavy) but can be inspected and potentially opened. 

In order to win, the user must successfully navigate throughout the rooms, find the priceless painting item, and return to the porch location using the leave. command. Upon completion of the game, the user will be prompted to enter the halt. command to complete the program. 

## Example starting commands in terminal
![alt text](https://github.com/alicia-leslie/COMP4400_FinalProject/blob/main/COMP4400_SampleStartingCommands.png?raw=true)
