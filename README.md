### UNDERWATERTALE

Hi guys, welcome to the UNDERWATERTALE github repo.
this README file contains a bunch of information about getting
set up with the project, as well as some resources for learning about
game development/godot. Your first assignment is to read through this
doc & get oriented with the project !

Here's a rough outline of the doc:

1. [Rules of the Repository](###rules-of-the-repository)
2. [Getting set up with Godot](###getting-set-up-with-godot)
3. [Getting set up with git](###getting-set-up-with-git)
4. [Getting started in Godot](###getting-started-in-godot)
5. [Godot/git Resources](###resources)

### Rules of the Repository

This section is only at the top of the list because it's the only one that
you'll probably need to reference throughout the lifetime of the project.
That being said, if you're walking through this file to get oriented with
the project, you won't need this yet, so please skip ahead to the
[Getting set up with godot](###getting-set-up-with-godot) section with this link.

#### RULES
1. This project is built in Godot 4.3 LTS. Please make sure that you are
using this version before getting started.
2. I highly recommend using Godot's built in IDE for editting GDScript code.
if you need VIM plugins, there is a plugin for that, I'm using
[this one](https://github.com/joshnajera/godot-vim). If you use another
IDE for whatever reason, make sure to update the .gitignore to ignore your
IDE-generated files, such as .idea/, .vscode/, etc.
3. If you're having trouble with accessing the repository, dm @slushtank on discord
for help.
4. If you're new to git, dm @slushtank (or really anyone who's experienced in
git, I'm sure they'd be glad to help) and they can help walk you through using it.
It's not as scary as it seems, but definitely nice to have some help with
to avoid catastrophe
5. please dont commit on main / production branches.. work on a feature branch and do a PR. 
I know that this can be a pain for things like small changes, but 
if weirdo code gets commited to the main branch it can cause problems.
plus, PRs inflate your contribution history yayy green bubbles
6. Generally speaking don't accept your own PRs without getting asking me
7. I encourage you guys to work together on features, but please be safe 
about it. I'd recommend always working on your own branch, in your own scene,
until you're ready to merge your changes with everyone elses.
8. do not commmit curses or otherwise dark evil wizard code.
9. see [Understanding the Project Filesystem](####understanding-the-project-filesystem)
for notes about directory structure.

### Getting set up with godot

Before we can get started on the project, we need to have Godot installed.
You can install it from [this link](https://godotengine.org/download/).
Make sure that you install the correct version for....

1. Your operating system, whether that be windows, mac, or linux;
2. For the project -- we'll be using Godot version 4.3 LTS;
3. For the compiler: we're using normal Godot, NOT the .NET version.

I haven't installed on windows in a bit, but I'm pretty sure for most
operating systems it's just an executable that you run; no installer.
For linux you probably have to do some funky stuff but if you're on
linnux you probably expected that already.

### Getting set up with git

This first section is going to be a quick setup guide for people that
have used git before. If you don't know how to use git, skip to the 
*I haven't used git* section.

#### I've used git 

**If you already know how to use git/GitHub**, go ahead and clone the repository
with the following command:

```shell
git clone https://github.com/gavindg/underwatertale.git
```

If that didn't work, first make sure you accepted the repo invite that
was sent to your email. otherwise, dm me on discord, it probably has something to do with perms.

#### I haven't used git

**If you've never used git/GitHub before**, no worries, now's a good time
to start! git will be our main 'Version control system' for this project,
and is how we will be sending our changes to each other. 

I'd recommend that you start by using the GitHub desktop app,
as it's very beginner friendly. If you would prefer to learn command-line
git, just ask me and I'll teach you the basics, or scroll to the end of this
document where I list one of my favorite CLI git resources.

##### Make a GitHub account + Install GitHub Desktop

if you don't already have one, sign up for an account on [GitHub's website](https://github.com).
Once you've done that, install GitHub Desktop from [this page](https://github.com/apps/desktop).
Move onto the next step once you've opened the GitHub Desktop app
and logged into your account.

##### Clone the Repository

In the world of git, we setup our workspace on our local computers by
'cloning' the repository. To do this on the GitHub desktop app, 
click the big rectangle button on the top left. For me, it says 'change repository',
but it might say something different if you don't have any repositories yet.

A UI sidebar should show up with a dropdown that says 'add'. Click
that dropdown and then click 'clone repository'.

In the popup that appears, click 'URL' near the top, then paste the
following URL into the searchbar:

`gavindg/underwatertale`

Then change the local path to be wherever you'd like the repo to be saved.
Make sure to write this down/remember this, as you'll need it for when
you open the project for the first time.
Once the clone has finished, the project files should be downloaded onto
your computer, and you'll be able to open the project in Godot!

##### Final note for git beginners

The best way I can describe git concisely is that it's like working on a google doc with friends,
but you send your changes manually instead of having them automatically show
up on the document when you type them.

Essentially, you will be making changes to the project on your own device,
and timestamping those changes with 'commits'. When you're ready to give
your changes to other people, you'll send them to everyone with a 'pull request'.
Because there will usually be a (very large) desync between when you make changes
and other people make changes, there will sometimes be conflicting changes,
which can cause *merge conflicts*. 

Merge conflicts *can accidentally lead to big headaches
for other developers*. 
git is not as scary as it seems, but if you really
have no experience, I would highly recommend asking me or another
experienced Git user for help before you commit your changes until you
get used to using it.

In the [Resources](###resources) section, I'll link a few sites and tutorials
that can help you get a more formal introduction to git, though as with 
most things, I think the best way to learn is to actually use the
technology and get some help from your peers.

### Getting started in Godot

#### Opening the project

To open the project, start by opening the Godot app that you downloaded
earlier. It should open to a screen listing all of your projects, but
UNDERWATERTALE won't be there. To add it to the list, click *import* near
the top, and then navigate to wherever you cloned the repository from
the *Getting setup with git* part. Navigate to the root directory of the
project -- you should see a file called *project.godot* -- and then hit
*select current folder* near the bottom. Then, click *Import & Edit* to
open the project for the first time.

#### Getting crackin in Godot

I don't want to take up this entire document explaining how to use Godot,
so I've linked a bunch of resources in the [Resources](###resources) section below
to get started. I'll also probably do a Godot workshop, as that was a pretty
fun meeting that I did last quarter.

#### Understanding the Project Filesystem

In the godot editor, *res://* is the root directory of the project.
To keep the project from becoming cluttered, we will be storing our 
files based on filetype and purpose. Most paths will be set up
using the following scheme:

`res://{file type}/{specifier 1}/{specifier 2}/.../file.ext`

so for example, our player's movement script would probably be stored
somewhere like `res://scripts/player/player_movement.gd`, and the player's
main scence might be stored at like `res://scenes/player/player.tscene`.

the one exception of this is that 'art' files will be stored in the same
manner, but in a dedicated 'art' directory. so instead of an NPC spritesheet
being stored at `res://sprites/npc/joe.png`, it'll be stored at
`res://art/sprites/npc/joe.png`. This is because there are a lot of
types of art assets, and we don't want to clutter the root directory
with a million toplevel subdirectories.

if you're still a bit confused about what all this means, feel free to ask
Gavin or any of his henchmen for help. but if you do understand this
formula, please try your best to follow it when creating new files for the
project. yayy

### Resources

#### Git

[This website](https://git-scm.com/book/en/v2) is the GOAT for learning 
about how git works. I would highly recommend **everyone** to read chapter
2 of this book, as it contains all the essential git basics.

That being said, I do think that the best way to learn git is to just start
using it, and to ask your homies for help when you get lost or need to
commit/push a change.

#### Godot

First, I should of course note that the the official 
[Godot docs](https://docs.godotengine.org/en/stable/index.html)
are an absolute goldmine of information, and they have a bunch of great
starter tutorials as well.

I would highly recommend reading through the 
[intro section of the Godot Docs](https://docs.godotengine.org/en/stable/getting_started/introduction/index.html)
as well as doing the
[Your first 2D game](https://docs.godotengine.org/en/stable/getting_started/introduction/index.html)
tutorial that they provide there.

As a side note, when editing gdscript code in the the engine, 
you can hold CTRL/Command and click on a class name to pull up
the documentation in-editor. this is so OP and is my favorite part of Godot.

As for tutorials outside of the official docs,
Jasper Flick and his website [Catlike Coding](https://catlikecoding.com/) 
is the mecca of learning game dev concepts in-depth. Instead of just showing
you how to do a thing like most YouTube tutorials do, he'll actually walk
you through the reasoning behind why he chooses to implement things in the
way he does. If you wanna understand gamedev and your engine and not just
how to get the job done quick n dirty, check out these tutorials.

Ok rant over. if you want his godot intro tutorial, 
[click here](https://catlikecoding.com/godot/).

That being said, there are some really good YouTube tutorials for Godot
as well.
[Brackeys](https://www.youtube.com/@Brackeys) 
is pretty much the goat of YouTube gamedev tutorials, but unfortunately most of his
tutorials are for Unity.

He does however have a few really good, really long Godot tutorials.
[here](https://www.youtube.com/watch?v=LOhfqjmasi0) is one that walks 
you through creating your first 2D game in Godot. Making a game & finishing
it is one of the best ways to get started creating games, so even though
this seems like a big commitment, I think it'll be worth it in the end.

### Closing Notes

If you made it to the end, thanks a ton for reading all of this!
