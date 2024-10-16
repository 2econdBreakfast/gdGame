XSM4 Extended State Machine (godot4)
==========================

Latest version : 4.1.0
This a MAJOR version that see's the addition of StateSound (inherits from StateAnimation)
(Careful since it might break your some StateAnimation objects from older projects)

A freely inspired implementation of [StateCharts](https://statecharts.github.io/what-is-a-statechart.html) for Godot 4. This plugin provides States composition (ie sub-States), regions (ie parallel States) and helper functions for animations and timers. It is licensed MIT and written by [ATN](https://gitlab.com/atnb).

For the very first state machine with XSM, try our [HelloWorld example](https://gitlab.com/atnb/xsm#hello-world) down this page. You can also look at the  simple examples provided with this plugin to have a glimpse of what is possible with it.

The plugin provides templates for your States. If you want to add a script to a State, use "inherit from script" to easily add from a State template.

Understanding XSM
-----------------

A Finite State Machine (FSM) is a way for game creators to separate their code's logic into different parts. In Godot, it would be in different Nodes. XSM allows to have substates of a State so that you don't have to create a complex inheritage pattern. You can simply add State Nodes as children of a State Node. If you do so, when a child is active, all his parents are active too and they are going to proceed (update).

If a State is inside a StateRegion, all its children are active or inactive at the same time, as soon as it is active or inactive.

It allows schemas such as :
<img src="readme_files/stateschart_composition.svg" alt="statechart" width="400"/>
<img src="readme_files/stateschart_regions.svg" alt="statechart" width="150"/>

_more on : [StateCharts](https://statecharts.github.io/what-is-a-statechart.html)_


How to use XSM
---------------

You can add a State node to your scene. This State will be the root of your XSM. Then you can add different States to this root and separate the logic of your scene into those different sub-States. You can also add a State as a child of another State and create complex trees of States by doing so.

There are many different types of States:
- State -> The basic type of State. All the other inherit from this one
- StateRegion -> All its child States will be active at the same time
- StateAnimation -> An easy to use State that will automatically play animations from an AnimationPlayer. The AnimationPlayer has to be either defined in the inspector or simply be a sibling of your XSM's root
- StateSound -> inherits from StateAnimation and allows you to add a sound to a state, even sync it with the animation
- StateLoop -> This State can loop (forward, backwards or ping-pong) through its children States
- StateRand -> A way to randomly chose one of the children States. A powerful way to switch between idle animations

By default, your XSM is enabled, you can disable it (or any branch of your XSM's tree) in the inspector.

You can use the same names for states in different branches of your StateMachine but if so THEIR PARENT NAMES MUST BE DIFFERENT. In the state_map and active_states_list, they will be referenced as "ParentName/ChildName" to differentiate them.

The state_root owns a history of the active_states_list, the size of which can be changed in the StateRoot's inspector. You can call `state_root.was_state_active("StateName")` to know if the StateName was active last frame. Careful: if two states have the same name, they are referenced as "ParentName/StateName" in the state's history.

Each State can have its own target (any Node of the scene, including another State). If you don't, XSM will get the root's ones. If the root does not have a target, it will use its parent as target.

If needed, you can print some debug infos. You can enable debug either in the root of in any State branch. This will print texts from the state that calls change_state(). If you call change_state inside _on_enter(), it will add nested debug texts. Then it also will notify when the change has been done (and reduce the indentation)

An empty State template is provided in [res://script_template/empty_state.gd](https://gitlab.com/atnb/xsm/-/blob/master/script_templates/empty_state.gd). You just need to add a script to your State and specify this one as a model.


**Abstract functions to inherit in you states**

When you enter a State (with `change_state("State")`), XSM will first exit the old branch. Starting from the common root of the new State and the old one, it will call `_before_exit()`, exit the children, then call `_on_exit()`.
Then it will enter the new branch. Starting from the common root of the new State and the old State, it will call `_on_enter()`, enter the proper child, then call `_after_enter()` for the child and eventually `_after_enter()` for the root. If the specified State is not the last of the branch, XSM is going to enter each following first chid.
During your scene's `_process()`, XSM will update the active root and call `_on_update()`, then `_on_update()` for its active child (or children if there are regions), `_after_update()` for the child and eventually `_after_update()` for the root.

Whenever a State has already been changed this frame, it cannot be changed again.
Note: During the change or if it did change a previous frame, the same happens with a twist. It cannot be changed UNLESS you call `change_state_node()` with a "force" boolean. This allows a State in its entering/exiting phase to be changed right away. This can help when you have to use change_state in the _on_enter() callback.

If you add a timer using the inspector, the state will call `_state_timeout()`
If you add any timer to a State (with `add_timer("name",time)`) as soon as the timer is done, it calls `_on_timeout("name")` and destroys itself. If it had this timer's name already as a child, the old timer is destroyed and a new one is created with the specified time.

In each State's script you extend, you can implement the following abstract public functions:
```python
#  func _on_enter(args) -> void:
#  func _after_enter(args) -> void:
#  func _on_update(_delta) -> void:
#  func _after_update(_delta) -> void:
#  func _before_exit(args) -> void:
#  func _on_exit(args) -> void:
#  func _state_timeout() -> void:
#  func _on_timeout(_name) -> void:
```

**Utility functions to call in your States**

In any State node, you can call the following public functions:

* `change_state("MyState") -> State`
   where "MyState" is the name of an existing Node State. If two states have the same name, you MUST add the parent's name before change_state("Parent/Child")

* `change_state("MyState", args_on_enter = null, args_after_enter = null, args_before_exit = null, args_on_exit = null)`
   The "change_state" method accepts arguments, to be able to pass variables to some inherited enter or exit functions in your states' logic. If "MyState" == "", then it will be considered as self.
   
* `change_state_node("MyState", args_on_enter = null, args_after_enter = null, args_before_exit = null, args_on_exit = null, force = false) -> State`
   Where my_state is an existing Node State. This function accepts the same arguments as change_state(). If no argument is entered, it will try to change state to self.
   
* `change_to_next( args_on_enter = null, args_after_enter = null, args_before_exit = null, args_on_exit = null) -> State:`
   Helper functions to change to the State defined in next_state.
   
* `change_to_next_substate() -> State:`
   Helper functions to ask to the parent state which one is the next_state (very useful for StateRand or StateLoop).
   
* `change_state_if(new_state: String, if_state: String) -> State`
   This one changes state only if the second state specified is active
   
* `change_state_node_force(new_state_node: State = null, args_on_enter = null, args_after_enter = null,args_before_exit = null, args_on_exit = null) -> State:`
   Very important ! This function forces the change even if the new_state_node is already active

* `is_active("MyState") -> bool`
   returns true if a state "MyState" is active in this xsm

* `get_active_substate()`
   if active, returns the active substate (or all the children if has_regions)

* `get_state("MyState") -> State`
   an alias for find_state_node()
   
* `get_previous_active_states(history_id) -> Dictionary`
   returns a dictionary with all the active States from `history_id + 1` frames ago

* `was_state_active(state_name: String, history_id: int = 0) -> bool`
   returns true if a state "MyState" was active in this xsm last frame (_physics_process)
   You can specify an history_id to get the result for older frames

* `find_state_node_or_null("MyState") -> State`
   returns the State Node "MyState", You have to specify "Parent/MyState" if "MyState" is not a unique name.


* `add_timer("Name", time)`
   adds a timer named "Name" and returns this timer
   when the time is out, the function `_on_timeout(_name)` is called
   
* `del_timer("Name")`
   deletes the timer "Name"
   
* `del_timers()`
   deletes all the timers of this State
   
* `has_timer("Name")`
   returns true if there is a Timer "Name" running in this State


For StateAnimation and StateSound only:

* `play("Anim")`
   plays the animation "Anim" of the State's AnimationPlayer

* `play_backwards("Anim")`
   plays the animation "Anim" of the State's AnimationPlayer, starting from the end

* `play_blend("Anim", custom_blend = 0.0, custom_speed = 1.0, from_end = false)`
   blends the animation "Anim" with the current one of the State's AnimationPlayer (plays both animation during the custom_blend time)

* `play_sync("Anim", custom_speed = 1.0, from_end = false)`
   synchronizes the animation "Anim" with the current animation of the State's AnimationPlayer

* `pause()`
   pauses the current animation

* `queue("Anim)`
   queues the animation "Anim" at the end of the State's AnimationPlayer list. If the current animation is looping, the queue will NOT play.

* `stop()`
   stops the current animation

* `is_playing("Anim)`
   returns true if "Anim" is playing


For StateSound only:

* `play_sound()`
   plays the sample sound using the inspector's parameters


For StateLoop only:

* `next_in_loop(args_on_enter = null, args_after_enter = null, args_before_exit = null, args_on_exit = null)`
   Change state to the next in loop, depending on the loop_mode

* `prev_in_loop(args_on_enter = null, args_after_enter = null, args_before_exit = null, args_on_exit = null)`
   Change state to the previous in loop, depending on the loop_mode

* `exit_loop(args_on_enter = null, args_after_enter = null, args_before_exit = null, args_on_exit = null)`
   Change state to the exit state defined in the loop's inspector



**Signals**

The States are calling different signals during their life :

* `signal state_entered(sender)`
* `signal state_exited(sender)`
* `signal state_updated(sender)`
* `signal state_changed(sender, new_state)`
* `signal substate_entered(sender)`
* `signal substate_exited(sender)`
* `signal substate_changed(sender, new_state)`
* `signal disabled()`
* `signal enabled()`

The root state can emit
* `signal some_state_changed(sender, new_state_node)`
* `signal pending_state_changed(added_state_node)`
* `signal pending_state_added(new_state_name)`
* `signal active_state_list_changed(active_states_list)`

A StateLoop can emit
* `signal looped()`


Hello World
-----------------

Your first try with XSM could be to :
* Install the module (using godot's AssetLib on the top of your editor)
* Activate the module (project / parameters / Extensions and check activate for XSM)
* Select the node that needs a StateMachine (for example a character)
* Add a new child node (or Ctrl-A) of type State
* You can now add two State nodes as children to your State (same as above : Ctrl-A)
* Add a script to the first State and chose the Empty State template.
* Add a script to the second State and chose the Empty State template.
* in the first script, in the _on_enter(_args) function, add a line with:
   `print("Hello world of state 1")`
* then in the _on_update(_delta) function, add:
 ```python
   if Input.is_action_just_pressed("ui_accept"):
      change_state("State2")
```
* in the second script, in the _on_enter(_args) function, add a line with:
   `print("Hello world of state 2")`
* then in the _on_update(_delta) function, add:
 ```python
   if Input.is_action_just_pressed("ui_accept"):
      change_state("State")
```
And here you are, you made your first state machine with XSM! You can launch it with F5 and press the spacebar to switch states.
The output should be explicit ;)


To go further, you can look at the examples provided with the addon.


Special Thanks
-----------------

To TealOrbiter and Frontrider1 for such kind and useful suggestions that make xsm getting better each version.

To flaticon.com and whoever made the icons used :
  ```
  https://www.flaticon.com/free-icon-font/chart-network_5528059
  https://www.flaticon.com/free-icon-font/chart-tree_5528048
  https://www.flaticon.com/free-icon-font/chart-connected_5528111
  https://www.flaticon.com/free-icon-font/chart-set-theory_5528101
  https://www.flaticon.com/free-icon/question_2669746
  ```

To piratesephiroth and MadFlyFish for a C# port of XSMv1 : https://github.com/MadFlyFish/XSM-Csharp

To DrPetter's sfxr allowing a quick add of sound effects : https://www.drpetter.se/project_sfxr.html

To André for the platformer's music : [link to add someday, the guy is shy]


What's next ?
-----------------

Well now you can create open source games with Godot and share, right ? Please report any bug and suggest enhancements to the plugin.

For any question, issue or request, `atn@lail.fr` or gitlab.
_See you_