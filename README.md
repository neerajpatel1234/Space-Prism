# Space-Prism

Student name: Neeraj Patel
Name of game/artwork: Delta Pilot (Data wing)

**Vision**
- Plan vision - ( The game will be very similar to the mobile game called “Data Wing” where the user will have the 
  option to fly their delta through a confined course to get to a finish line under a certain amount of time. There will be 3 levers,
  Easy, medium, and hard. )
- New Vision - ( The game that I have made is the 2D Version of “Data Wing” and has the same option of flying their rocket through a 
  confined course to get to a finish line under a certain amount of time. The completion version having 3 levels, Easy, medium, 
  and hard. )

**Achievement**
- I was able to achieve all of the fundamental goals that I set out. Which was having the user be able to control a ship that 
  will only accelerate in the direction that it is facing when the accelerate button is pressed. With a working game, you can 
  play and win.

**Screenshots of the Application**

- <img width="650" alt="image" src="https://github.com/neerajpatel1234/Space-Prism/assets/114114241/d4feb923-a03d-41ab-a8c4-8759f4e5c57d">
- <img width="300" alt="image" src="https://github.com/neerajpatel1234/Space-Prism/assets/114114241/43aa33b3-476f-4bfc-8eaa-38d7552fcc84">   <img width="300" alt="image" src="https://github.com/neerajpatel1234/Space-Prism/assets/114114241/aece30d0-7f1b-4314-9585-2355bbafaedf">


**Technical Challenges**
- One of the major challenges that I faced was having the game go through different levels when the player wins. I was able to achieve 
  this by using an enum, as I did for the player state. Having different enums for the easy, medium, and hard levels. 
  Beginning with easy then when level equals easy it will draw easy. Then when player y is at the finish line and the time is less than 10,
  it will set the level to the next level. However, if the time is not less than 10 will reset the game. 
- Another major challenge was doing collision detection for all of the planets as they are three different sizes and are all in different 
  locations. One of the first methods that I tested was to have all of the x and y coordinates of the planets in a list and have a for 
  loop that recursively goes through the location and does the collision detection. However, during testing, I found that this method 
  would not work on certain occasions as it would skip certain frames. This is why I had to do the fallback code which was just individual 
  collision detection. 

**Reflection**
- The game that I had initially aspired to create was significantly more challenging than I had originally expected. 
  As always, the fundamental movements of the game with rotations and consistent acceleration did not work too well with the 8-bit 
  frame rate which I wanted to make. But other than the game having to be a simplified version of the vision. I have still achieved most 
  of the soft headlines. Creating a game up to the completed version. Which has 3 levels, an easy, medium and a hard level with all of them 
  done to a satisfactory standard. Where the game can run semi-smoothly. With all if not most of the fundamental ideas archives, 
  but not the greatest standard. Something that I would change if I was given the chance to create this game again would be to not base 
  the game too much on another game. Also, given I have more time with processing of find what works and the limitations of what I can do. 
  As some of the features that I wanted for my game, I did not practically know how to code or implement into the game.   
