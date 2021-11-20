# dcs-bios-hubscripts
dcs-bios hubscripts are used in conjunction with DCS-BIOS http://dcs-bios.a10c.de/

## Installation

#### DCS-BIOS installation
The DCS-BIOS documentation is available online at https://dcs-bios.readthedocs.org.
If you are a new user, start with the first section, Installation.

#### Hubscript installation
DCS Bios > Dashboard > Add
https://dcs-bios.readthedocs.io/en/latest/hub-scripts.html

## Scripts
- [p51TempControl.lua](p51TempControl.lua) - script that maintains p51 oil and engine temp at exactly redline by modulating 
the oil and coolant doors. 

  Debugging in Lua Console:
  ```
  enterEnv("tempControl.lua")
  return THIS_AIRCRAFT .. " power: " .. MP.POWER .. ", oil: ".. OIL.MSG .. " coolant: " .. COOL.MSG
  ```
  
- [p51TankSwitcher.lua](p51TankSwitcher.lua) - script that maintains p51 lt and rt fuel tank with 1 gallon 

  Debugging in Lua Console:
  ```
  enterEnv("p51TankSwitcher.lua")
  return MESSAGE
  ```
  
- [p51YawDamper.lua](./p51YawDamper.lua) - script that adjusts rudder trim to keep ball centered

  Debugging in Lua Console:
  ```
  enterEnv("p51YawDamper.lua")
  return MESSAGE
  ```
