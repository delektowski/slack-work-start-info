## General info
A script for announcing the start and finish working hours on a slack channel.

## Technologies
* Bash
* Slack

## Setup
You have to create own Slack webhook (very easy)

https://api.slack.com/messaging/webhooks

Then change 

```.env.example```

into 

```.env```

and fill variables with the proper content.

!IMPORTANT FOR LINUX!

Change ```-v+8H``` to ```-d '+4 hour'```




## Features
* announcing start and finish working hours on a Slack channel
* showing a random quote from an external API

## Contact
Created by [Marcin Delektowski](mailto:marcin.delektowski@gmail.com) - feel free to contact me!
