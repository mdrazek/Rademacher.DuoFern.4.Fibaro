# Rademacher.DuoFern.4.Fibaro
Plugin for Fibaro Home Center makes communication with Rademacher HomePilot for control DuoFern roller shutter devices.

# Compatibility
Plugin has been tested only with Fibaro Home Center 3 [v5.130.64] and Rademacher HomePilot [v5.5.10] but can work with other versions too.

# Configuration
Script has been written in LUA language.

Just import plugin as a virtual device into Fibaro Home Center for each one DuoFern roller shutter device.
After that go to the variable configuration tab of device settings, set correct values and save changes.

Variables that require configuration:
* ip - HomePilot IP address, for example: 192.168.0.100
* deviceId - unique ID as a number of DuoFern device (you can find it in web console view when you choose device in Rademacher Home Center from the list)
* pollingTime - set refresh query time to check state of DuoFern device (value is a number given as a seconds), value "0" means do not make any request
