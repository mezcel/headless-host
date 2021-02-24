## Use Windows 10 wifi hotspot with no internet connection

Source: [link 1]( https://superuser.com/questions/1195436/use-windows-10-wifi-hotspot-with-no-internet-connection#:~:text=Right%20click%20the%20Internet%20Connect,Apply%2C%20OK%20to%20save%20changes. ) [link 2]( https://superuser.com/a/1229057 )

---

## Answer

Two resolutions. First being easier, second being overly complex that even I don't want to approach as it requires programming.

### Resolution One:
#### You use a hostednetwork if your wireless adapter is capable. (Usually they are capable.)

1. Open an elevated command prompt. Win+X and choose CMD (Admin) OR type in "cmd" or "command prompt" into Windows Search by typing into Start Menu and then right click "Command Prompt" and select "Run As Administrator"

2. Check if your system is capable run this command: ```netsh wlan show drivers```. Scroll down to ```Hosted network supported```. If it says ```Yes``` you are in luck; if ```No``` there is no easy alternative and don't continue.

3. Run the following command to allow and set up your hostednetwork but look below first.

    ```sh
    netsh wlan set hostednetwork mode=allow ssid=%ssid% key=%pass% keyUsage=persistent
    ```
    * Replace ```%ssid%``` with your Wifi or "Hotspot" Name or SSID. E.g. s```sid=MyGreatHotspot```. Replace %pass% with your Wifi or "Hotspot" Password. It must be 8 characters long at a minimum. E.g. ```key=strongPasswordsAreWEAK```.

4. After that run the command, ```netsh wlan start hostednetwork```, to start the "Hotspot" broadcast. Right now you can play without internet connection after all devices connect. Remember to check IP addresses of all your individual devices in order to connect to each other. The hotspot's IP Address usually is "192.168.137.1".

    * If you want to share your internet connection or for further reference, continue on:

5. Open Run (Win + R) or by searching for Run and enter in ```ncpa.cpl```, then press Enter. A new adapter has shown in the screen it should say something along the lines of "Microsoft Hosted Network Virtual Adapter". (Optional if you're OCD, rename that one if its says "L.A.N Connection* 15" or rather to like "Hotspot"). Right click the Internet Connect Source you want to share internet from and choose "Properties." Go to the "Sharing" Tab and checkmark or toggle on "Allow other network users to connect through this computer's Internet Connection." Apply, OK to save changes.

6. You should be all set! :)

* If you want to stop the hostednetwork, in an elevated command prompt you run the command: ```netsh wlan stop hostednetwork```

---

### Resolution Two:
#### This is taken from [this post]( https://superuser.com/questions/1178550/how-to-force-enable-soft-ap-to-allow-hostednetwork ) from user Linard Arquit

> In case writing your own application is a possibility, have a look at the WiFi Direct API, which offers a legacy mode. Enabling the legacy mode will create a SoftAP with the specified SSID and password. However, specifying no password doesn't seem to be supported.

> Have a look at the IoTOnboarding sample to see the legacy mode in action (and to have a better 'documentation' than what Microsoft officially provides): IotOnboarding/IoTOnboardingService/OnboardingAccessPoint.cs

