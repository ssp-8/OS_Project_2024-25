## CSL 3030 - Operating Systems 2024 - 25 project.
### Keyboard character manipulation tool

Keyboard is an essential I/O Device of any computer, since it allows the most important interaction with the system - User input as "Strings". 
So, providing as many customizations possible to the user would be the target of any keyboard driver developer.

We have tried customizing the driver of **xv-6**, a customizable Operating System developed by MIT.

Here, we have implemented following customizations:

#### Helpful
  - Enigma Mode: Helps in encrypting the string typed by the user into an enigma cipher, helpful in systems where actual message visibility must be none, as it can be tapped.
  - String cases: We have given an option of choosing 3 new cases for alphabets: **Pascal Case**, **camel Case** and **snake_case**, helping in increasing productivity while typing (mainly for developers).
  - Clipboard , Copy and Paste: The basic xv-6 OS doesn't have a clipboard or copy-paste feature. This was implemented in a naive way.
  - Clear: The clear terminal option was implemented to help the user interact in a better way.
  - Previous Line: Pressing the up arrow key would help the user to get the previous line text again, but this is applicable to the very immediate previous line as of now.
  - Auto completion: When tab is pressed, if the string typed matches as a prefix of the preloaded dictionary, then it is auto completed.
  - Sticky keys: An accessibility feature to the users.
  - Keyboard layout switching: Helpful for users who wish to work with a specific layout.
  - Terminal Color change: Helpful for  users who wish to have a different color of the terminal.


#### Annoying
A playful mode trying to annoy user, to promote the fact that if a driver malfunctions, the consequences are quite drastic.

The project is a basic trial of driver manipulation
