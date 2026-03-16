# coal_project
16-bit Breakout-style arcade game developed in x86 Assembly (NASM). Implements real-time collision detection, custom 0/1 bitmap rendering for UI, and direct manipulation of video memory (0xb800 segment) using BIOS interrupts (int 10h/16h). Fully functional within DOSBox.
Breakout: x86 Assembly Game
A fully functional, 16-bit arcade-style "Breakout" game written from scratch in x86 Assembly. This project explores low-level system programming, BIOS interrupts, and direct manipulation of Video RAM.

Technical Stack
Language: x86 Assembly (NASM/TASM compatible)

Environment: DOSBox (16-bit Real Mode)

Core Concepts:

Video Memory: Direct manipulation of memory segment 0xb800 for real-time rendering.

BIOS Interrupts: Using int 10h for screen management and int 16h for keyboard polling.

Hardware Interaction: Bitmapped character patterns and direct register manipulation.

Key Features
Real-time Gameplay: Responsive paddle movement using keyboard scancodes.

Collision Engine: Custom logic for ball-to-wall, ball-to-paddle, and ball-to-brick physics.

Visual Feedback: Dynamic score tracking and a lives system.

Graphical UI: Custom "YOU WON" and "GAME OVER" screens rendered via 0/1 bitmap arrays.

How to Run
Install DOSBox.

Place main.asm and your assembler (nasm.exe or tasm.exe) in a folder.

Open DOSBox and mount the folder:
mount c c:\your_folder_path

Assemble and Link:
nasm main.asm -o main.com

Execute:
main.com
