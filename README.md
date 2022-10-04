# Darwin-Ach Simple Demo for C++

This is a quick demonstration about the utilisation of the Darwin-Ach system to control the Darwin-OP via C++

## Step 1: Start the Darwin-OP

Follow the normal process to turn on the Darwin-OP.  Please reference the Darwin-Lofaro-Legacy / Darwin-Ach manual for startup prosedures.  For your reference we will be running the Darwin-Ach server.

1. Ensure the Darwin-OP is suspended in the air by the strap on its back.

2. Login to the Darwin-OP via SSH

3. Start the Darwin-Ach Server on the Darwin-OP.

```
$ darwin-ach start server
```

## Step 2 (optional): Start the client if running the example on a the backpack computer

If you are runnin this example on the backpack computer then you will need run the Darwin-Ach client on that computer.

1. Login to the Darwin-OPs backpack computer 

2. Start the Darwin-Ach Client on the backpack computer
```
$ darwin-ach start client
```

## Step 3: Compile and run the example

This example will set the angle of all of the joints to 0.1 rad then to -0.1 rad with a half period of 5.0 seconds. This will also set the maximum velocity and torque to 0.5 rad/sec and 50% maximum torque.

1. Compile the example
```
$ cd darwin-ach-simple-demo-cpp
$ make clean
$ make
```

This will make an executable named "text"

2. Run the executable
```
$ ./test
```

# Code Explained

1. Make the Darwin Ach Client object and set the system to "reference mode".  Reference mode alls you to control every joint on the robot. 

```
/* Make System Object */
DarwinAchClient dac = DarwinAchClient();
dac.setRefMode(MODE_REF);
```

3. Turn on the joint's power
This step turns on the Darwin-OP's joints' power.  The "true" means that the system will block until a conformation that the joints have been turned on has been received.  If set to "false" it will not block.

```
/* Turn On System */
r = dac.cmd(DARWIN_CMD_ON, true);
if( r == DARWIN_CMD_OK ){ r=0; }
else{ printf("1\n"); return 1; }
```

2. Stage all joints to 0.0 rad.

```
/* Get into home positon */
for(int i = DARWIN_MOTOR_MIN; i <= DARWIN_MOTOR_MAX; i++)
{
  dac.stageRefPos(i, 0.0);
}
```

3. Set (stage) the lower body torque and angular velocity to 50% of maximum and 0.5 rad/sec respectively 

```
/* Set Lower Body to be low torque and slow */
for(int i = DARWIN_MOTOR_MIN_LOWER; i <= DARWIN_MOTOR_MAX_LOWER; i++)
{
  dac.stageRefVel(i, 0.5);
  dac.stageRefTorque(i, 0.5);
}
```

4. Send the updated reference to the Darwin-OP and wait 2.0 seconds to allow the robot to get into position

```
dac.postRef();
dac.sleep(2.0);
```

5. Stage all motors to 0.1 rad then -0.1 rad ever 5.0 seconds then send (post) the values to the Darwin-OP.

```
double val = 0.1;
while(1)
{
  for(int i = DARWIN_MOTOR_MIN; i <= DARWIN_MOTOR_MAX; i++)
  {
    dac.stageRefPos(i, val);
  }
  dac.postRef();
  val = -val;
  dac.sleep(5.0);
}
```











