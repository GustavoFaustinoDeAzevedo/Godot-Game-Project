# Godot 3D Grid Movement Base (Study Project)

This is a base project developed in **Godot Engine 4**, created as a continuous learning sandbox. The main goal of this repository is to learn, test, and implement fundamental mechanics for 3D grid-based games, such as *Dungeon Crawlers* or puzzles.

As I learn new logic and tools within Godot, this project will serve as my testing ground and structural foundation for future games.

## 🛠️ Implemented Features

So far, the core movement and collision logic is complete. Current mechanics include:

* **Grid Movement:** The character moves fluidly from cell to cell using `Tween` (position interpolation).
* **Safe Relative Rotation:** A 90º and 180º turning system immune to *Gimbal Lock* or "snapping to the wrong side", utilizing modular math (`posmod`) combined with true accumulative rotations.
* **Collision Detection:** Anti-clipping system using `RayCast3D`, configured to check the character's local forward direction before validating movement.
* **3D Mapping:** Environment structure set up with `GridMap` and `MeshLibrary`, separating floors and walls into distinct layers with natively generated physical collisions.

## 🚀 Next Steps (To-Do)

Since this is a long-term learning project, here are some features I plan to explore and add in the future:

- [ ] Add environment interactions (Doors, buttons, or keys).
- [ ] Create a State Machine to prevent movement during events or menus.
- [ ] Add collectible items to the map.
- [ ] Improve visuals by replacing placeholder blocks with custom 3D models.

## 💻 Technologies Used

* **Engine:** Godot Engine 4.7
* **Language:** GDScript

## 🎮 How to Run the Project

1. Clone this repository:
   `git clone https://github.com/GustavoFaustinoDeAzevedo/Godot-Game-Project.git`
2. Open Godot Engine 4.
3. Click on **Import** and select the `project.godot` file in the root folder of the project.
4. Press `F5` to run the main scene.

**Current Controls:**
* **Up Arrow:** Move forward.
* **Left Arrow:** Turn 90º left.
* **Right Arrow:** Turn 90º right.
* **Down Arrow:** Turn around (180º).
