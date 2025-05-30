# Endless Runner
A high-performance endless runner game case study showcasing advanced Unity development patterns and optimization techniques for mobile platforms.

![endlessrunner](https://github.com/user-attachments/assets/b1f67ac9-81a8-4705-bade-dab550dd1bc2)

## Features
Seamless Infinite Gameplay: Continuous level loop system with no loading interruptions

Advanced Memory Management: Zero garbage collection during gameplay through comprehensive object pooling

Dynamic Level Generation: Randomized prop placement with configurable spawn points

Visual Level Editor: In-editor tool for designing and reordering game levels

Mobile-Optimized: Performance tuned for mobile devices with URP rendering pipeline

Modular Architecture: Dependency injection pattern for maintainable and testable code

New Input System: Project uses new input system to allow touch swipe controls/pc keyboard at the same time


## Technical Architecture
### Dependency Injection
Built on VContainer for clean separation of concerns and testable architecture.

### Asset Pool System
Implements circular buffer/queue for continuous level streaming

All game objects are pooled and reused to eliminate instantiation overhead

Levels seamlessly stitch together in an infinite loop

### Memory Management
Addressable Assets: All props and levels loaded via Addressables system

Addler Memory Management library Integration: Automatic memory cleanup when parent objects are destroyed

Scene-Based Cleanup: Memory released on additive scene unloads

### Procedural Generation
Spawn points defined per level chunk with randomized prop selection

Buildings, trees, props, and roadblocks have configurable spawn locations

Maintains visual variety while ensuring consistent gameplay flow

![endlessrunner-level](https://github.com/user-attachments/assets/fca4878f-32a5-430b-8fc6-2e7c755e9d80)


### Reactive UI System
R3 (Reactive Extensions) for responsive UI updates

Observer pattern implementation for clean UI-logic separation

Real-time score and state management

### Level Editor
The custom level editor provides intuitive tools for level design:

Access: Unity Menu → Game Design → Edit Levels

Features:

Drag-and-drop level reordering

Add/remove levels without code changes

![endlessrunner-leveleditor](https://github.com/user-attachments/assets/30eda489-f0f6-4523-9abd-58f2637f8655)
