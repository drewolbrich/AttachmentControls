# FB13143132

If a RealityView in a volume has an attachment with controls, often the attachment's controls will not respond to user input.

![screenshot](https://github.com/drewolbrich/AttachmentControls/assets/12141562/0e863bd1-ced7-4005-84d0-e84a25df88e5)

## Repro steps:

1. Run the attached app in Xcode, in the visionOS simulator.
2. Move the app's window to the left side of the simulator screen.
3. Select the window's Open Volume button.
4. In the volume that appears, select the New Color button.

## Expected behavior

The color of the sphere in the volume changes to a random color.

## Observed behavior

The Open Volume button doesn't work, and the sphere does not
change color. Furthermore, the Open Volume's hover effect does not appear.

The observed behavior described above only happens about 1/4 of the time.
If the sphere does change color, follow these steps:

1. Select the window's Close Volume button
2. Select the window's Open Volume button again.
3. Select the New Color button again.

It may be necessary to repeat these steps several times before the observed behavior occurs.
