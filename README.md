# Explanation on how to use

## What does this actually do?
To use this tool, you should only use the "h.exe" file included on this page.  It contains all of the files necessary for the project to work, places them in the correct directories, and executes the applications which need to be executed.  You would begine by deploying "h.exe" to the Back office system and executing it.  The file would then create directory "C:\WOL", move file numbers 3 and 4 above to the directory that was created, would execute file number 3 to configure the dell Back office system as described above, place the WOL.exe in the Back office computers Global Startup folder, execute WOL.exe, then delete file number 3 and itself.  So at this point, the Back office has been configured and all useless files not needed for the solution to function have been removed.  All WOL.exe does, when executed, is utilize WakeMeOnLan.exe's commandline features.  It will first have WakeMeonLan scan the network to determine the devices that are on the network if it is the first time running, then will, using a placeholder which will keep track of the iterations of the infinite loop, broadcast Wake On LAN packets to every device in the Local Area network for 9 iterations after a 2 second pause, then will scan the network again to look for new or offline devices for the 10th iteration, then start again.  Recently, I have also modified the solution so that, when the WakeMeOnLan tool detects that a new device has been added to the local area network, it will remotely and automatically configure that machine’s network adapter to enable Wake On Lan settings, which will prevent the need for technicians to manually do this on machines that are deployed.  The pseudo code is as follows:


FunctionToScanForDevices ($placeholder = 0)

Infinite loop start
sleep (2 sec)
If $placeholder < 10
{
    $placeholder = functionToBroadcastWOLPacketsToAllDevices ($placeholder)
}
Else
{
    $placeholder = FunctionToScanForDevices ($placeholder)
	FunctionToEnableWOLForNewDevices ()
}
EndofInfinateLoop

Func functionToBroadcastWOLPacketsToAllDevices ($thecurrentplaceholder)
{
    Run ( WakeMeOnLan.exe /wakeallnetworkdevices )
    $thecurrentplaceholder += 1
    Return $thecurrentplaceholder
}
    
Func FunctionToScanForDevices ($thecurrentplaceholder2)
{
   Run ( WakeMeOnLan.exe /scannetwork )
   $thecurrentplaceholder2 = 0
   Return $thecurrentplaceholder2
}

Func FunctionToEnableWOLForNewDevices ()
{
	$content = ReadFileToArray ( "C:\WOL\WakeMeOnLan.cfg" ) ;This will read the "cfg" file containing all devices found by FunctionToScanForDevices ()
	If Not FileExists ( "C:\WOL\devices.ini" ) then ;This will see if the script has already created an ini file containing its own copy of devices discovered by WakeMeOnLan
		;Code here will scan all devices found in WakeMeOnLan cfg file, create devices.ini in C:\WOL and populate this file with all of the devices found in WakeMeOnLan.cfg, and will then remotely enable WOL settings for the network adapters of all of the devices.
	Else ;If the devices ini file already exists
		;The code here will scan the WakeMeOnLan.cfg file, compare the contents of the cfg file with the contents of the devices.ini file, and any entry which is not in the devices.ini file but is in the WakeMeOnLan.cfg file will be added to the devices.ini file.  Then, the WOL settings for the network adpater of the remote device will be enabled remotely.
	Endif
}
}

## Explanation of each file
1. h.exe (source code h.au3) is the main file to be deployed to the Back office computers (the server for the store basically) and executed. 
2. WOL.exe (source code WOL.au3) is the executable which will perform the the actual main process in the background unbeknownst to the end user.
3. multiplatform_201607260046.exe is the executable created with Dell-Command | Configure, a tool which enables an IT Admin to create profiles and packages of hardware settings for Dell Enterprise client systems, which will configure the Dell Back office computer BIOS settings to enable the feature which automatically powers on the system when the following conditions are met: 1) the system detects that it is receiving power, and 2) when the system detects that it was shutdown abruptly due to power loss.  
4. WakeMeOnLan.exe is an application developed by Nirsoft, who has written some of the most useful IT system utilities I have ever used.  WakeMeOnLan.exe can scan the local area network for online devices, then saves that information in a configuration file located in the same folder.  It then uses this configuration file during any subsequent network scans to determine which devices are online, which are offline, and if a new device has been added to the network.  It can also generate and send the Wake on LAN packets to a particular device, a set of devices, or broadcast it to the entire LAN.
5. Paexec.exe is a freely distributable version of psexec.  Both of these tools are able to run commands on remote systems connected to the same LAN.


## Why did I create this?
I wrote developed this tool while working for Arbys Corporate because of the very high volume of calls that the service desk received on a daily basis with not enough resources to handle them.  One of the calls that we would get was in regards to powering on all of the appliances when the store had lost power: a very simple task that doesn't require a call, since all they have to do is press the power button on all of the devices, but still generated a large number of calls.  I wrote this tool in order to automate the process of powering on a store's devices when power was restored to the store.

