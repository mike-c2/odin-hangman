# Hangman Game

## Introduction

This is a text-based Hangman game that was made as part of [The Odin Project](https://www.theodinproject.com). This project is written in Ruby.

The project details can be found at [Project: Hangman](https://www.theodinproject.com/lessons/ruby-hangman).

For more details about the game, see [Hangman (board game)](<https://en.wikipedia.org/wiki/Hangman_(game)>)

## How to Play

Try to guess the word by entering one letter at a time. You can only get 7 guesses wrong before losing the game. If you fully reveal the word, then you win.

There are some options you can enter during the game:

- Help: Print out these options.
- Print: Prints out the game board.
- Quit: Leave the game.
- Exit: Leave the game (same as Quit).
- Restart: Start the game over.
- Save: Save the game to file.
- Load: Load a game that was previously saved and continue playing that.

For example, if you type "exit", the game will terminate.

All input is case insensitive.

# Saving and Loading Games

All files will be saved to \<game directory\>/save_files, where \<game directory\> is wherever the hangman.rb file is located. If the directory does not exist, then it will be created.

For saving, the game will be converted to JSON format, then saved to a file, named by the player.

For loading, the game will read the file entered by the player, convert it to JSON, then convert that to the game object.

If either of these action fail, then a message is displayed and the current game just continues.
