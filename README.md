# ns_charLoadout
ns_charLoadout is a plugin for NutScript framework  
It was developed and tested using NutScript 1.1B

The plugin brings new character creation step: loadout.  
A player will be able to choose from certain equipment. 
In order to configure it, use the function below. 

# Functions
## Shared
### PLUGIN:RegisterLoadoutItem(faction, id, price, quantity)  
faction - faction's enum  
id - item's unique id   
price - number of points taken when adding this item to loadout   
quantity - how many of these items will player be able to take    

Use this function in PLUGIN:InitializedPlugins() hook in sh_plugin.lua

# Example

Check out sh_plugin.lua to see the implementation
