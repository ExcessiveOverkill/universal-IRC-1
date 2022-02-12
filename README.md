# universal-IRC-1
Universal Industrial Robot Controller. V1 is based on using LinuxCNC in combination with Odrives.
Everything in this repo is specifically for my R2000iA setup, but can be modified for other robots.
See this video for the R2000iA conversion.

# Uses
The purpose of this is to allow old industrial robots that are at end of life to be reused.
It will run robots as CNC machines, allowing direct Gcode input as well as options for spindle/coolant/aux IO control.
It does not support any other method of control input. yet...

# Safety
If it isn't obvious, saftey should be a major consideration when working with all industrial robots, especially large ones. Estops are not optional, always have a way of mechanically cutting power easily available, such as shutoffs or power contactors. Software should never be relied on to handle an estop situation.
This controller lacks many of the enhanced safety features of modern controllers, the only collision detection is position error based. The robot will apply FULL TORQUE before erroring out.
Think what the robot would do if it was trying its best to hurt you, if it could do that before you can estop, then you need to change your setup to be safer.
Be aware of the robot at all times, since Odrives have a higher PWM frequency and drive the motors slowly, some robots may be almost comletely silent while moving.

# Supported Robots
Currently I have only tested this setup on a Fanuc R-2000iA 200F robot, theoretically it should be able to directly control ANY fanuc robot that uses an RJ3iB controller, with only simple parameter changes needed.
It is meant to control robots with AC servo motors, but there is the possibility of using different drives to run DC or stepper motors.
The main limit for compatability is the encoder protocol, custom protocols may be added to support most rs422/rs485 based encoders without any hardware changes.

# Hardware
I am using a Mesa 5i24-25 FPGA card for handling the main interfaces between LinuxCNC and the encoders/Odrives/Aux IO.
Connected to it are 2 Mesa 7i44 boards(8ch rs422/rs485). One of which is setup to handle 8 fanuc encoders, the other is for 2 Smart Serial devices and 4 odrives(with rs422 tranceivers).
One of the smart serial devices is a Mesa 7i84 IO card for handling 24v IO, the other port is left unused currently.

# Software
I am using linuxCNC 2.8 with some custom HAL components along with a modified driver for the fanuc encoders.
The 5i24 FPGA hostmot2 firmware has custom changes to add support rs485 fanuc encoders.
The odrives have custom firmware that makes them no longer need to calibrate before enabling, and allow encoder position to be written over uart.
