Project structure:

"art/": 2d/3d assets
"audio/": music and sfx
"fonts/": fonts 

"src/": Everything Godot-related
"src/main.tscn": Entry node. Here you can load plugins etc.
"src/components/": reusable components of the project.
"src/globals/": auto-load singletons. In scripts, they start with G letter (e.g. GEventBus)
"src/screens/": screens of the project. Screens can be UI screens (menu, settings here) or 2d/3d screens (game)
"src/resources": theme, labelsettings, other Godot stuff
