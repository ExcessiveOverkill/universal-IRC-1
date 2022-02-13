# universal-IRC-1
Universal Industrial Robot Controller. V1 is based on using LinuxCNC in combination with Odrives.

Everything in this repo is specifically for my R2000iA setup, but can be modified for other robots.

# Uses
The purpose of this is to allow old industrial robots that are at end of life to be reused at a hobbyist/enthusiast level. 

It will run robots as CNC machines, allowing direct Gcode input as well as options for spindle/coolant/aux IO control.

It does not support any other method of control input. yet...

# Safety
If it isn't obvious, safety should be a major consideration when working with all industrial robots, especially large ones. Estops are not optional, always have a way of mechanically cutting power easily available, such as shutoffs or power contactors. Software should never be relied on to handle an estop situation.

This controller lacks many of the enhanced safety features of modern controllers, the only collision detection is position error based. The robot will apply FULL TORQUE before erroring out.

Think what the robot would do if it was trying its best to hurt you, if it could do that before you could estop, then you need to change your setup to be safer.

Be aware of the robot at all times, since Odrives have a higher PWM frequency and drive the motors slowly, some robots may be almost completely silent while moving.

# Supported Robots
Currently I have only tested this setup on a Fanuc R-2000iA 200F robot, theoretically it should be able to directly control ANY fanuc robot that uses an RJ3iB controller, with only simple parameter changes needed.

It is meant to control robots with AC servo motors, but there is the possibility of using different drives to run DC or stepper motors.

The main limit for compatibility is the encoder protocol, custom protocols may be added to support most rs422/rs485 based encoders without any hardware changes.

# Hardware
I am using a Mesa 5i24-25 FPGA card for handling the main interfaces between LinuxCNC and the encoders/Odrives/Aux IO.

Connected to it are 2 Mesa 7i44 boards(8ch rs422/rs485). One of which is set up to handle 8 fanuc encoders, the other is for 2 Smart Serial devices and 4 odrives(with rs422 transceiver).

One of the smart serial devices is a Mesa 7i84 IO card for handling 24v IO, the other port is left unused currently.

# Software
I am using linuxCNC 2.8 with some custom HAL components along with a modified driver for the fanuc encoders.

The 5i24 FPGA hostmot2 firmware has custom changes to add support rs485 fanuc encoders.

The odrives have custom firmware that makes them no longer need to calibrate before enabling, and allow encoder position to be written over uart.

# Controls
LinuxCNC is responsible for all of the servo control loops, path planning, kinematics, and gcode interpreting. 

Most of the general components are documented here: https://linuxcnc.org/docs/html/man/man9/

There is a forum for linuxCNC related questions as well: https://forum.linuxcnc.org/

# Motors
Most industrial robots use PMAC(permanent magnet alternating current) servo motors.

I am using Odrives to run the motors since they are cheap and readily available. The issue is they are only rated for 56v, while most robots use ~250v motors. Drives also use trapezoidal commutation instead of the sinusoidal commutation used by the industrial servos. These issues result in the Odrives only being able to achieve around 10% of the maximum motor speed in my case.

They are still able to apply full torque as it is proportional to current, which the Odrives have a surplus off.

# Brakes
Most industrial robots have brakes built into the motors. They keep the robot in place when off, where otherwise it may fall due to gravity.

They are normally locked, power must be applied to allow the motors to spin.

You should be very careful if you are unlocking the brakes on a robot without servo power. The arm WILL move quite quickly if there is nothing to hold it in place or slow it down. NOTE: removing a motor will have the same effect.

Depending on the robot, it may fall due to gravity, or spring upwards due to a counterweight and balancer.

When I first unlocked the brakes to move my robot into a safe working position, I shorted together the motor phases to only allow the robot to move very slowly.

Fanuc uses 90vdc brakes on all of their motors I have seen. They however open at around only 50v. I am using 75v since it was easily available due to my power supply selection.

Motor brakes will require a diode and resistor or other type of surge arrester to handle the inductive voltage spike when being turned off. I am currently using a diode and 2 ohm resistor across the brake terminals, I am planning on trying a higher value resistor to decrease the closing time. I tried with no surge protection and the EMI spike caused the computer running linuxCNC to crash, so don't do that.

# Encoders
Encoders were the most challenging part of this entire project. Thankfully, the hostmot2 firmware that the FPGA card runs on is open source, allowing custom encoder interfaces to be written with only slight pain and suffering.

Odrives are designed to handle quadrature input from the encoders, but very few industrial encoders output it. Instead they often use a proprietary protocol with no public documentation.

I could not just swap in quadrature encoders because I need absolute multiturn positioning. I need the position of each joint at all times(even after restarts) and the angle of the motor for commutation purposes.

It wasn't worth ditching the industrial fanuc encoders only to need to remake a jankier, less reliable version of basically the same thing.

The encoders the R2000iA uses are A64i and A128i, they are able to provide 16 bit single and multi turn position, 8 bit commutation, a motor temp ok bit, and a battery ok bit. Both position counts are retained by battery backup, the commutation is absolute and will be accurate even after complete power loss.

The encoders are connected with rs485. LinuxCNC and hostmot2 already support rs422 fanuc encoders, which were what I assumed my robot used(WRONG!).

The encoders I am using are able to be run by either 2 wire (rs485) or 4 wire (rs422) communication.

In the 4 wire mode, an ~8us request pulse must be sent to the encoder, then it will respond with the data at 1 Mbaud.

The 2 wire mode requires a request byte rather than just a pulse(the byte can be all zeros however), then the encoder will respond, however in a different format than the 4 wire.

The 2 wire mode operates at 2.7 Mbaud and MUST be polled at 8khz, the 4 wire mode does not care about the polling rate, it will respond no matter what.

I was forced to add 2 wire support to the hostmot2 firmware because the robot used the 2 wire mode and only had 2 data wires run to each encoder.

LinuxCNC takes the commutation data from the encoder and sends it to the Odrive over UART. The Odrive is programmed so that all it needs to run is the commutation value, no initial encoder offset or index searching is needed.

LinuxCNC uses the actual positional data from the encoder for the servo PID loops, then sends a torque value to the Odrives.

# Power
The robot originally ran on 480v 3 phase, which got dropped to ~200v by a transformer before going into the servo amplifier. At full voltage the robot is rated at 2.5kw cont. and 5kw peak according to the manual. The cont. output according to the motors is 20.4kw, which is insane.

I decided to use 4 12v server power supplies to get 48v @ 3kw, which is probably overkill, but they are cheap. The 48v goes directly into the Odrives for motor power.

To power the brakes(~200w) I added an additional 24v supply to the 48v motor supply to get 72v.

Conveniently the entire robot can now be run off of a standard 120v plug(as long as it doesn't exceed 1.8kw for an extended time).

# Future Upgrades/Changes
The biggest thing I am working on improving is the servo drives. 10% speed just isn't going to fly. I've been working on designing a driver similar to the STMBL drive, only capable of handling the full power I need for the robot servos. Along with including a much better brake control and estop system.

The new drives would likely fall under a v2 of this repository, as the majority of the hardware and low level software will be changed.

# Support Me
Youtube: https://www.youtube.com/c/ExcessiveOverkill

https://www.reddit.com/r/ExcessiveOverkill/

Patreon: https://www.patreon.com/excessiveoverkill
