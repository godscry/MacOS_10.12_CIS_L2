#!/bin/sh

# OSX for Pentesting (Mavericks/Yosemite)
#
# A fork of OSX for Hackers (Original Source: https://gist.github.com/brandonb927/3195465)
# Taken from https://gist.github.com/gabemarshall/33f1944e198b1b5ca878

# Ask for the administrator password upfront

start_ms=$(ruby -e 'puts (Time.now.to_f).to_i')

echo "This script requires that System Integrity Protection be disabled."
echo "Has this been done? (y or n)"
read response

if [ $response == "y" ]
then
	echo "SIP Disabled Confirmed, Proceeding with script" >> ~/CIS_config.log 2>&1
else
	echo "Please disable SIP and try again" >> ~/CIS_config.log 2>&1
	exit
fi

echo "Have you read through the script prior to running this? (y or n)"
read bcareful

if [ $bcareful == "y" ]

then

  echo "Alright, lets get started. First, you'll need to give this script admin privileges (however, do not run as root)" >> ~/CIS_config.log 2>&1
 
else
  echo "Goodbye" >> ~/CIS_config.log 2>&1
  exit
fi

sudo -v


echo "and away we go!" >> ~/CIS_config.log 2>&1

echo "#############################################################################" >> ~/CIS_config.log 2>&1
echo "Starting the CIS Compliance Configuration Scripts" >> ~/CIS_config.log 2>&1
echo "#############################################################################" >> ~/CIS_config.log 2>&1

echo "Creating log file located at ~/CIS_config.log" >> ~/CIS_config.log 2>&1
touch ~/CIS_config.log >> ~/CIS_config.log 2>&1

echo "" >> ~/CIS_config.log 2>&1
echo "Setting computer name" >> ~/CIS_config.log 2>&1
laptop="ARCACM" >> ~/CIS_config.log 2>&1
tld=".ad.faa.gov" >> ~/CIS_config.log 2>&1
# grabbing mac serial number...
serial=$(ioreg -l | grep "IOPlatformSerialNumber"| cut -d ""="" -f 2 | cut -d "\"" -f 2) >> ~/CIS_config.log 2>&1
case "$serial" in
	"[ENTER SERIAL NUMBER]" )
		sudo /usr/sbin/scutil --set ComputerName "[SET HOSTNAME]"
		sudo /usr/sbin/scutil --set LocalHostName "[SET HOSTNAME]"
		sudo /usr/sbin/scutil --set HostName "[SET HOSTNAME]"
		echo "$model"
		echo "$serial"
		sudo /usr/sbin/scutil --get ComputerName >> ~/CIS_config.log 2>&1
		sudo /usr/sbin/scutil --get LocalHostName >> ~/CIS_config.log 2>&1
		sudo /usr/sbin/scutil --get HostName >> ~/CIS_config.log 2>&1
	;;
	* )
		sudo /usr/sbin/scutil --set ComputerName "$laptop$serial"
        sudo /usr/sbin/scutil --set LocalHostName "$laptop$serial"
        sudo /usr/sbin/scutil --set HostName "${laptop}${serial}${tld}"
        echo "$model"
        echo "$serial"
        sudo /usr/sbin/scutil --get ComputerName >> ~/CIS_config.log 2>&1
        sudo /usr/sbin/scutil --get LocalHostName >> ~/CIS_config.log 2>&1
        sudo /usr/sbin/scutil --get HostName >> ~/CIS_config.log 2>&1
	exit 0 >> ~/CIS_config.log 2>&1
	;;
esac >> ~/CIS_config.log 2>&1



###############################################################################
# General UI/UX
###############################################################################

echo "" >> ~/CIS_config.log 2>&1
echo "Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window" >> ~/CIS_config.log 2>&1
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName >> ~/CIS_config.log 2>&1
echo "Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window - Complete" >> ~/CIS_config.log 2>&1

#echo "" >> ~/CIS_config.log 2>&1
echo "Disable Photos.app from starting everytime a device is plugged in" >> ~/CIS_config.log 2>&1
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true >> ~/CIS_config.log 2>&1
echo "Disable Photos.app from starting everytime a device is plugged in - Complete" >> ~/CIS_config.log 2>&1

 
###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input
###############################################################################
 
echo "" >> ~/CIS_config.log 2>&1
echo "Turn off keyboard illumination when computer is not used for 5 minutes" >> ~/CIS_config.log 2>&1
defaults write com.apple.BezelServices kDimTime -int 300 >> ~/CIS_config.log 2>&1
defaults read com.apple.BezelServices kDimTime >> ~/CIS_config.log 2>&1
echo "Turn off keyboard illumination when computer is not used for 5 minutes - Complete" >> ~/CIS_config.log 2>&1

###############################################################################
# Screen
###############################################################################

echo "" >> ~/CIS_config.log 2>&1
echo "Enable HiDPI display modes (requires restart)" >> ~/CIS_config.log 2>&1
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true >> ~/CIS_config.log 2>&1
sudo defaults read /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled >> ~/CIS_config.log 2>&1
echo "Enable HiDPI display modes (requires restart) - Complete" >> ~/CIS_config.log 2>&1

###############################################################################
# Finder
###############################################################################

echo "" >> ~/CIS_config.log 2>&1
echo "Avoiding the creation of .DS_Store files on network volumes" >> ~/CIS_config.log 2>&1
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true >> ~/CIS_config.log 2>&1
defaults read com.apple.desktopservices DSDontWriteNetworkStores >> ~/CIS_config.log 2>&1
echo "Avoiding the creation of .DS_Store files on network volumes - Complete" >> ~/CIS_config.log 2>&1

###############################################################################
# Time Machine
###############################################################################
 
echo "" >> ~/CIS_config.log 2>&1
echo "Preventing Time Machine from prompting to use new hard drives as backup volume" >> ~/CIS_config.log 2>&1
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true >> ~/CIS_config.log 2>&1
echo "Preventing Time Machine from prompting to use new hard drives as backup volume - Complete" >> ~/CIS_config.log 2>&1

echo "" >> ~/CIS_config.log 2>&1
echo "Disabling local Time Machine backups" >> ~/CIS_config.log 2>&1
hash tmutil &> /dev/null && sudo tmutil disablelocal >> ~/CIS_config.log 2>&1
echo "Disabling local Time Machine backups - Complete" >> ~/CIS_config.log 2>&1


###############################################################################
# Misc Additions
###############################################################################
 
echo "" >> ~/CIS_config.log 2>&1
echo "Disable the sudden motion sensor as its not useful for SSDs" >> ~/CIS_config.log 2>&1
sudo pmset -a sms 0 >> ~/CIS_config.log 2>&1
echo "Disable the sudden motion sensor as its not useful for SSDs - Complete" >> ~/CIS_config.log 2>&1

echo "" >> ~/CIS_config.log 2>&1
echo "Generating db for the locate command" >> ~/CIS_config.log 2>&1
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist >> ~/CIS_config.log 2>&1
echo "Generating db for the locate command - Complete" >> ~/CIS_config.log 2>&1

###############################################################################
# Applying SBCC settings from NIST 800-179 OSX Security Spreadsheet
# Based off of NIST, CIS, and DISA-STIG
###############################################################################

echo "" >> ~/CIS_config.log 2>&1
echo "Disable inactivity logout in order to ensure preservation of user data" >> ~/CIS_config.log 2>&1
#Disable inactivity logout in order to ensure preservation of user data
sudo defaults write /Library/Preferences/.GlobalPreferences com.apple.autologout.AutoLog delete >> ~/CIS_config.log 2>&1
echo "Disable inactivity logout in order to ensure preservation of user data - Complete" >> ~/CIS_config.log 2>&1

echo "" >> ~/CIS_config.log 2>&1
echo "Destroy the FileVault key when system goes to sleep, forcing user to enter password when system comes out of sleep" >> ~/CIS_config.log 2>&1
#Destroy the FileVault key when system goes to sleep, forcing user to enter password when system comes out of sleep
sudo pmset destroyfvkeyonstandby 1 >> ~/CIS_config.log 2>&1
echo "Destroy the FileVault key when system goes to sleep, forcing user to enter password when system comes out of sleep - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# Disable automatic connection to captive portals when connecting via wi-fi
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "Disabling the ability to connect automatically to captive portals" >> ~/CIS_config.log 2>&1
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false >> ~/CIS_config.log 2>&1
sudo defaults read /Library/Preferences/SystemConfiguration/com.apple.captive.control Active >> ~/CIS_config.log 2>&1
echo "Disabling the ability to connect automatically to captive portals - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
#############################################################################
#
# ACTUAL CIS SETTINGS START HERE
#
#############################################################################
#############################################################################

#############################################################################
# 1.2 Enable Auto Update
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "1.2 Enable Auto Update" >> ~/CIS_config.log 2>&1
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
sudo defaults read /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled >> ~/CIS_config.log 2>&1
echo "1.2 Enable Auto Update - Completed" >> ~/CIS_config.log 2>&1

#############################################################################
# 1.3 Enable app update installs
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "1.3 Enable app update installs" >> ~/CIS_config.log 2>&1
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool true
sudo defaults read /Library/Preferences/com.apple.commerce AutoUpdate >> ~/CIS_config.log 2>&1
echo "1.3 Enable app update installs - Completed" >> ~/CIS_config.log 2>&1

#############################################################################
# 1.4 Enable system data files and security update installs - 'ConfigDataInstall'
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "1.4 Enable system data files and security update installs - 'ConfigDataInstall'" >> ~/CIS_config.log 2>&1
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true
sudo defaults read /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall >> ~/CIS_config.log 2>&1
sudo defaults read /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall >> ~/CIS_config.log 2>&1
echo "1.4 Enable system data files and security update installs - 'ConfigDataInstall' - Completed" >> ~/CIS_config.log 2>&1

#############################################################################
# 1.5 Enable OS X update installs
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "1.5 Enable OS X update installs" >> ~/CIS_config.log 2>&1
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdateRestartRequired -bool true
sudo defaults read /Library/Preferences/com.apple.commerce AutoUpdateRestartRequired >> ~/CIS_config.log 2>&1
echo "1.5 Enable OS X update installs - Completed" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.1.1 Disable Bluetooth, if no paired devices exist - Bluetooth is paired
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.1.1 Disable Bluetooth, if no paired devices exist - Bluetooth is paired" >> ~/CIS_config.log 2>&1
sudo sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0
sudo killall -HUP blued
sudo defaults read /Library/Preferences/com.apple.Bluetooth ControllerPowerState >> ~/CIS_config.log 2>&1
echo "2.1.1 Disable Bluetooth, if no paired devices exist - Bluetooth is paired - Completed" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.1.3 Show Bluetooth status in menu bar
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo ""  >> ~/CIS_config.log 2>&1
echo "2.1.3 Show Bluetooth status in menu bar"  >> ~/CIS_config.log 2>&1

for i in $(find /Users -type d -maxdepth 1)
do
  if [ "$i" = "/Users/Shared" ] || [ "$i" = "/Users" ]; then
    /bin/echo "Found '$i', ignored"
    /bin/echo "Found '$i', ignored"  >> ~/CIS_config.log 2>&1
  else
    PREF=$i/Library/Preferences/com.apple.systemuiserver.plist
    /bin/echo "Checking user: '$i': "  >> ~/CIS_config.log 2>&1
    if [ -e $PREF ]; then
      /bin/echo "Found"
      EXTRAS=`defaults read $PREF menuExtras`
      echo "Current settings: $EXTRAS"  >> ~/CIS_config.log 2>&1
      echo $EXTRAS | grep -q "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"  >> ~/CIS_config.log 2>&1
      if [ $? -eq 0 ]; then
        /bin/echo "Found existing string, exiting"  >> ~/CIS_config.log 2>&1
        /bin/echo "Found existing string, exiting"
        break  >> ~/CIS_config.log 2>&1
      else
        /bin/echo "Adding WiFi Status" && defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"  >> ~/CIS_config.log 2>&1
        /bin/echo "New Setting: " && sudo defaults read $PREF menuExtras  >> ~/CIS_config.log 2>&1
        /bin/echo "Adding value"
        /bin/echo "Adding value"  >> ~/CIS_config.log 2>&1
        ACCOUNT=`/bin/echo $i | cut -d'/' -f 3`
        echo $ACCOUNT
        sudo chown -Rv $ACCOUNT:staff $PREF  >> ~/CIS_config.log 2>&1
        /bin/echo "New Setting: " && sudo defaults read $PREF menuExtras  >> ~/CIS_config.log 2>&1
      fi
    fi
  fi
done
echo "2.1.3 Show Bluetooth status in menu bar - Complete"  >> ~/CIS_config.log 2>&1

#############################################################################
# 2.2.1 Enable Set time and date automatically
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.2.1 Enable Set time and date automatically" >> ~/CIS_config.log 2>&1
sudo systemsetup -setnetworktimeserver time.nist.gov >> ~/CIS_config.log 2>&1
sudo systemsetup -setusingnetworktime on >> ~/CIS_config.log 2>&1
echo "2.2.1 Enable Set time and date automatically - Completed" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.2.2 Ensure time set is within appropriate limits
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.2.2 Ensure time set is within appropriate limits" >> ~/CIS_config.log 2>&1
sudo systemsetup -getnetworktimeserver >> ~/CIS_config.log 2>&1
sudo ntpdate -sv time.nist.gov >> ~/CIS_config.log 2>&1
echo "2.2.2 Ensure time set is within appropriate limits - Completed" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.2.3 Restrict NTP server to loopback interface
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.2.3 Restrict NTP server to loopback interface" >> ~/CIS_config.log 2>&1
#Make backup of file to be modified
sudo cp /etc/ntp-restrict.conf /etc/ntp-restrict.conf.bak >> ~/CIS_config.log 2>&1
#Change permissions so file can be modified
echo "ntp-restrict before:"
cat /etc/ntp-restrict.conf
sudo chmod 777 /etc/ntp-restrict.conf >> ~/CIS_config.log 2>&1
#Add needed line to file and then reset the permissions on file
sudo echo "restrict lo" >> /etc/ntp-restrict.conf
sudo echo "interface ignore wildcard" >> /etc/ntp-restrict.conf
sudo echo "interface listen lo" >> /etc/ntp-restrict.conf
sudo chmod 644 /etc/ntp-restrict.conf >> ~/CIS_config.log 2>&1
echo "" >> ~/CIS_config.log 2>&1
echo "ntp-restrict after:" >> ~/CIS_config.log 2>&1
cat /etc/ntp-restrict.conf >> ~/CIS_config.log 2>&1
echo "" >> ~/CIS_config.log 2>&1
echo "Difference in files:" >> ~/CIS_config.log 2>&1
diff /etc/ntp-restrict /etc/ntp-restrict.bak >> ~/CIS_config.log 2>&1
echo "2.2.3 Restrict NTP server to loopback interface - Completed" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.3.1 Set an inactivity interval of 20 minutes or less for the screen saver
#############################################################################
/bin/echo ""  >> ~/CIS_config.log 2>&1
/bin/echo "2.3.1 Set an inactivity interval of 20 minutes or less for the screen saver"  >> ~/CIS_config.log 2>&1
UUID=`ioreg -rd1 -c IOPlatformExpertDevice | grep "IOPlatformUUID" | sed -e 's/^.* "\(.*\)"$/\1/'`  >> ~/CIS_config.log 2>&1
/bin/echo $UUID  >> ~/CIS_config.log 2>&1
for i in $(find /Users -type d -maxdepth 1)
do
  ACCOUNT=`/bin/echo $i | cut -d'/' -f 3`  >> ~/CIS_config.log 2>&1
  echo $ACCOUNT  >> ~/CIS_config.log 2>&1
  if [ "$i" = "/Users/Shared" ] || [ "$i" = "/Users" ]; then
    /bin/echo "Found '$i', ignored"  >> ~/CIS_config.log 2>&1
  else 
    PREF=$i/Library/Preferences/ByHost/com.apple.screensaver.$UUID.plist
    /bin/echo "File being modified: " && /bin/echo $PREF  >> ~/CIS_config.log 2>&1
    /bin/echo "Checking user: '$i': "  >> ~/CIS_config.log 2>&1
    if [ -e $PREF ]; then
      /bin/echo "Found"  >> ~/CIS_config.log 2>&1
        /bin/echo "Current Setting: " && sudo defaults read $PREF idleTime  >> ~/CIS_config.log 2>&1
        /bin/echo "Changing Value to 20 minutes" && sudo defaults write $PREF idleTime 1200  >> ~/CIS_config.log 2>&1
        /bin/echo "New Setting: " && sudo defaults read $PREF idleTime  >> ~/CIS_config.log 2>&1
    else
      /bin/echo "File not found, creating file"  >> ~/CIS_config.log 2>&1
      sudo touch $i/Library/Preferences/ByHost/com.apple.screensaver.$UUID.plist
      /bin/echo "Current Setting: " && sudo defaults read $PREF idleTime  >> ~/CIS_config.log 2>&1
      /bin/echo "Changing Value to 20 minutes" && sudo defaults write $PREF idleTime 1200  >> ~/CIS_config.log 2>&1
      sudo chown -Rv $ACCOUNT:staff $PREF  >> ~/CIS_config.log 2>&1
      /bin/echo "New Setting for " && echo $ACCOUNT && ": " && sudo defaults read $PREF idleTime  >> ~/CIS_config.log 2>&1
    fi
  fi
done
/bin/echo "2.3.1 Set an inactivity interval of 20 minutes or less for the screen saver - Completed"  >> ~/CIS_config.log 2>&1

#############################################################################
# 2.3.2 Secure screen saver corners
#############################################################################
/bin/echo ""  >> ~/CIS_config.log 2>&1
/bin/echo "2.3.2 Secure screen saver corners"  >> ~/CIS_config.log 2>&1
echo "	Verify that 6 is not returned for any key value for any user"  >> ~/CIS_config.log 2>&1
for i in $(find /Users -type d -maxdepth 1)
do
  if [ "$i" = "/Users/Shared" ] || [ "$i" = "/Users" ]; then
    /bin/echo "Found '$i', ignored"  >> ~/CIS_config.log 2>&1
  else
    PREF=$i/Library/Preferences/com.apple.dock.plist
    /bin/echo $PREF  >> ~/CIS_config.log 2>&1
    /bin/echo "Checking user: '$i': "  >> ~/CIS_config.log 2>&1
    if [ -e $PREF ]; then
      /bin/echo "Found"  >> ~/CIS_config.log 2>&1
      /bin/echo "Current Settings: " && defaults read $PREF | grep -i wvous  >> ~/CIS_config.log 2>&1
      /bin/echo "Changing Corner Value to 5 (Bottom Left Corner)" && sudo defaults write ~/Library/Preferences/com.apple.dock.plist "wvous-bl-corner" -int 5  >> ~/CIS_config.log 2>&1
      /bin/echo "Changing Modifier Value to 0 (Bottom Left Modifier)" && sudo defaults write $PREF "wvous-bl-modifier" -int 0  >> ~/CIS_config.log 2>&1
	  echo $ACCOUNT
	  ACCOUNT=`/bin/echo $i | cut -d'/' -f 3`
	  sudo chown -Rv $ACCOUNT:staff $PREF  >> ~/CIS_config.log 2>&1
      /bin/echo "Current Settings: " && defaults read $PREF | grep -i wvous  >> ~/CIS_config.log 2>&1
	 else
	  /bin/echo "File not found, creating file"  >> ~/CIS_config.log 2>&1
      sudo touch $PREF
      /bin/echo "Current Settings: " && defaults read $PREF | grep -i wvous  >> ~/CIS_config.log 2>&1
      /bin/echo "Changing Corner Value to 5 (Bottom Left Corner)" && sudo defaults write ~/Library/Preferences/com.apple.dock.plist "wvous-bl-corner" -int 5  >> ~/CIS_config.log 2>&1
      /bin/echo "Changing Modifier Value to 0 (Bottom Left Modifier)" && sudo defaults write $PREF "wvous-bl-modifier" -int 0  >> ~/CIS_config.log 2>&1
      sudo chown -Rv $ACCOUNT:staff $PREF  >> ~/CIS_config.log 2>&1
      /bin/echo "New Setting for " && echo $ACCOUNT && ": " && sudo defaults read $PREF idleTime  >> ~/CIS_config.log 2>&1
      echo $ACCOUNT
	  ACCOUNT=`/bin/echo $i | cut -d'/' -f 3`
      sudo chown -Rv $ACCOUNT:staff $PREF  >> ~/CIS_config.log 2>&1
      /bin/echo "Current Settings: " && defaults read $PREF | grep -i wvous  >> ~/CIS_config.log 2>&1
    fi
  fi
done
/bin/echo "2.3.2 Secure screen saver corners - Completed"  >> ~/CIS_config.log 2>&1

#############################################################################
# 2.3.3 Verify Display Sleep is set to a value larger than the Screen Saver
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.3.3 Verify Display Sleep is set to a value larger than the Screen Saver" >> ~/CIS_config.log 2>&1
sudo pmset -c displaysleep 15 >> ~/CIS_config.log 2>&1
echo "2.3.3 Verify Display Sleep is set to a value larger than the Screen Saver - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.3.4 Secure screen saver corners
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.3.4 Secure screen saver corners" >> ~/CIS_config.log 2>&1
echo "This item is configured manually, ensure the proper Configuration Profile is enabled" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.4.1 Disable Remote Apple Events
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.4.1 Disable Remote Apple Events" >> ~/CIS_config.log 2>&1
sudo systemsetup -setremoteappleevents off >> ~/CIS_config.log 2>&1
echo "2.4.1 Disable Remote Apple Events - Completed" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.4.2 Disable Internet Sharing
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.4.2 Disable Internet Sharing" >> ~/CIS_config.log 2>&1
echo "	Value returned should be 0 for all network interfaces" >> ~/CIS_config.log 2>&1
echo "	or file should not exist" >> ~/CIS_config.log 2>&1
sudo defaults read /Library/Preferences/SystemConfiguration/com.apple.nat | grep -i Enabled >> ~/CIS_config.log 2>&1
echo "2.4.2 Disable Internet Sharing - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.4.3 Disable Screen Sharing
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.4.3 Disable Screen Sharing" >> ~/CIS_config.log 2>&1
echo "	Deviation allowed for VNC Access when connecting remotely" >> ~/CIS_config.log 2>&1
echo "	(Primary purpose is for Web Application Scanning Team)" >> ~/CIS_config.log 2>&1
sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false >> ~/CIS_config.log 2>&1
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist >> ~/CIS_config.log 2>&1
sudo sudo launchctl load /System/Library/LaunchDaemons/com.apple.screensharing.plist >> ~/CIS_config.log 2>&1
echo "2.4.3 Disable Screen Sharing - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.4.4 Disable Printer Sharing
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.4.4 Disable Printer Sharing" >> ~/CIS_config.log 2>&1
echo "	The output should be empty. If 'Shared: Yes' is in the output there are still shared printers." >> ~/CIS_config.log 2>&1
echo "	If this value exists then disable Printer Sharing from System Preferences | Sharing" >> ~/CIS_config.log 2>&1
system_profiler SPPrintersDataType | egrep "Shared: Yes" >> ~/CIS_config.log 2>&1
echo "2.4.4 Disable Printer Sharing - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.4.5 Disable Remote Login
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.4.5 Disable Remote Login" >> ~/CIS_config.log 2>&1
echo "	Deviation allowed for SSH access" >> ~/CIS_config.log 2>&1
sudo systemsetup -getremotelogin >> ~/CIS_config.log 2>&1
echo "2.4.5 Disable Remote Login - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.4.6 Disable DVD or CD Sharing
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.4.6 Disable DVD or CD Sharing" >> ~/CIS_config.log 2>&1
echo "If 'com.apple.ODSAgent' appears in the result the control is not in place. No result is compliant." >> ~/CIS_config.log 2>&1
sudo launchctl list | egrep ODSAgent >> ~/CIS_config.log 2>&1
echo "2.4.6 Disable DVD or CD Sharing - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.4.7 Disable Bluetooth Sharing
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.4.7 Disable Bluetooth Sharing" >> ~/CIS_config.log 2>&1
echo "	Verify that all values are Disabled" >> ~/CIS_config.log 2>&1
sudo system_profiler SPBluetoothDataType | grep State >> ~/CIS_config.log 2>&1
echo "2.4.7 Disable Bluetooth Sharing - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.4.8 Disable File Sharing
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.4.8 Disable File Sharing" >> ~/CIS_config.log 2>&1
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.AppleFileServer.plist >> ~/CIS_config.log 2>&1
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.smbd.plist >> ~/CIS_config.log 2>&1
echo "2.4.8 Disable File Sharing - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.4.9 Disable Remote Management
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.4.9 Disable Remote Management" >> ~/CIS_config.log 2>&1
echo "	Ensure /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/MacOS/ARDAgent is not present as a running process" >> ~/CIS_config.log 2>&1
echo "	If present then in System Preferences: Sharing, turn off Remote Management" >> ~/CIS_config.log 2>&1
ps -ef | egrep ARDAgent >> ~/CIS_config.log 2>&1
echo "2.4.9 Disable Remote Management - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.5.1 Disable "Wake for network access"
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.5.1 Disable 'Wake for network access'" >> ~/CIS_config.log 2>&1
sudo pmset -a womp 0 >> ~/CIS_config.log 2>&1
sudo pmset -g | grep -i womp >> ~/CIS_config.log 2>&1
echo "2.5.1 Disable 'Wake for network access' - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.5.2 Disable sleeping the computer when connected to power
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.5.2 Disable sleeping the computer when connected to power" >> ~/CIS_config.log 2>&1
sudo pmset -a sleep 0 >> ~/CIS_config.log 2>&1
sudo pmset -g | grep -i sleep >> ~/CIS_config.log 2>&1
echo "2.5.2 Disable sleeping the computer when connected to power - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.6.2 Enable Gatekeeper
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.6.2 Enable Gatekeeper" >> ~/CIS_config.log 2>&1
sudo spctl --master-enable
echo "2.6.2 Enable Gatekeeper - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.6.3 Enable Firewall
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.6.3 Enable Firewall" >> ~/CIS_config.log 2>&1
sudo defaults read /Library/Preferences/com.apple.alf globalstate >> ~/CIS_config.log 2>&1
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1 >> ~/CIS_config.log 2>&1
sudo defaults read /Library/Preferences/com.apple.alf globalstate >> ~/CIS_config.log 2>&1
echo "2.6.3 Enable Firewall - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.6.4 Enable Firewall Stealth Mode
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.6.4 Enable Firewall Stealth Mode" >> ~/CIS_config.log 2>&1
sudo defaults read /Library/Preferences/com.apple.alf stealthenabled >> ~/CIS_config.log 2>&1
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -int 1 >> ~/CIS_config.log 2>&1
sudo defaults read /Library/Preferences/com.apple.alf stealthenabled >> ~/CIS_config.log 2>&1
echo "2.6.4 Enable Firewall Stealth Mode - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.6.5 Review Application Firewall Rules
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.6.5 Review Application Firewall Rules" >> ~/CIS_config.log 2>&1
echo "***	This review will have to be done manually ***" >> ~/CIS_config.log 2>&1
echo "2.6.5 Review Application Firewall Rules - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.6.6 Enable Location Services (Disabled)
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.6.6 Enable Location Services" >> ~/CIS_config.log 2>&1
echo "This setting is to be disabled in ESC environment, not enabled" >> ~/CIS_config.log 2>&1
sudo launchctl unload /System/Library/LaunchDaemons/com.apple.locationd.plist >> ~/CIS_config.log 2>&1
echo "2.6.6 Enable Location Services - Complete"  >> ~/CIS_config.log 2>&1

#############################################################################
# 2.8.1 Time Machine Auto-Backup
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.8.1 Time Machine Auto-Backup" >> ~/CIS_config.log 2>&1
echo "	Deviation for setting as no central location for backups to be stored has been defined" >> ~/CIS_config.log 2>&1
echo "2.8.1 Time Machine Auto-Backup - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.8.2 Time Machine Volumes Are Encrypted
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.8.2 Time Machine Volumes Are Encrypted" >> ~/CIS_config.log 2>&1
echo "	Deviation for setting as no central location for backups to be stored has been defined" >> ~/CIS_config.log 2>&1
echo "2.8.2 Time Machine Volumes Are Encrypted - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.9 Pair the remote control infrared receiver if enabled (Disabled)
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "2.9 Pair the remote control infrared receiver if enabled" >> ~/CIS_config.log 2>&1
echo "This setting is to be disabled in ESC environment, not enabled" >> ~/CIS_config.log 2>&1
sudo defaults write /Library/Preferences/com.apple.driver.AppleIRController.plist DeviceEnabled -bool false
sudo defaults read /Library/Preferences/com.apple.driver.AppleIRController.plist DeviceEnabled >> ~/CIS_config.log 2>&1
echo "2.9 Pair the remote control infrared receiver if enabled - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 2.10 Enable Secure Keyboard Entry in terminal.app
#############################################################################
/bin/echo ""  >> ~/CIS_config.log 2>&1 2>&1
echo "2.10 Enable Secure Keyboard Entry in terminal.app"  >> ~/CIS_config.log 2>&1 2>&1

for i in $(find /Users -type d -maxdepth 1)
do
  if [ "$i" = "/Users/Shared" ] || [ "$i" = "/Users" ]; then
    /bin/echo "Found '$i', ignored"  >> ~/CIS_config.log 2>&1 2>&1
  else
    PREF=$i/Library/Preferences/com.apple.Terminal.plist
    /bin/echo $PREF  >> ~/CIS_config.log 2>&1 2>&1
    /bin/echo "Checking user: '$i': "  >> ~/CIS_config.log 2>&1 2>&1
    if [ -e $PREF ]; then
		/bin/echo "Found"  >> ~/CIS_config.log 2>&1 2>&1
		/bin/echo "Current Settings: " && defaults read $PREF SecureKeyboardEntry  >> ~/CIS_config.log 2>&1 2>&1
		sudo defaults write "$i/Library/Preferences/com.apple.Terminal.plist" SecureKeyboardEntry -bool true >> ~/CIS_config.log 2>&1
    ACCOUNT=`/bin/echo $i | cut -d'/' -f 3`
		echo $ACCOUNT  >> ~/CIS_config.log 2>&1 2>&1
		sudo chown -Rv $ACCOUNT:staff "$i/Library/Preferences/com.apple.Terminal.plist"  >> ~/CIS_config.log 2>&1 2>&1
		sudo defaults read "$f/Library/Preferences/com.apple.Terminal.plist" SecureKeyboardEntry >> ~/CIS_config.log 2>&1
	else
		/bin/echo "Plist not found, creating"  >> ~/CIS_config.log 2>&1 2>&1
		sudo touch $PREF
    ls $i/Library/Preferences | grep com.apple.Terminal  >> ~/CIS_config.log 2>&1 2>&1
		sudo defaults write "$i/Library/Preferences/com.apple.Terminal.plist" SecureKeyboardEntry -bool true >> ~/CIS_config.log 2>&1
    ACCOUNT=`/bin/echo $i | cut -d'/' -f 3`
		echo $ACCOUNT  >> ~/CIS_config.log 2>&1 2>&1
		sudo chown -Rv $ACCOUNT:staff "$i/Library/Preferences/com.apple.Terminal.plist"  >> ~/CIS_config.log 2>&1 2>&1
		sudo defaults read "$i/Library/Preferences/com.apple.Terminal.plist" SecureKeyboardEntry >> ~/CIS_config.log 2>&1
    fi
  fi
done
/bin/echo "2.3.2 Secure screen saver corners - Completed"  >> ~/CIS_config.log 2>&1 2>&1

#############################################################################
# 3.1.1 Retain system.log for 90 or more days
#############################################################################
echo ""  >> ~/CIS_config.log 2>&1
echo "3.1.1 Retain system.log for 90 or more days"  >> ~/CIS_config.log 2>&1
sudo sed -i .bak 's/system.log mode=0640 format=bsd rotate=seq compress file_max=5M all_max=50M/system.log mode=0640 format=bsd rotate=utc compress file_max=5M all_max=50M ttl=90/g' /etc/asl.conf  >> ~/CIS_config.log 2>&1
echo "3.1.1 Retain system.log for 90 or more days - Complete"  >> ~/CIS_config.log 2>&1

#############################################################################
# 3.1.2 Retain appfirewall.log for 90 or more days
#############################################################################
echo ""  >> ~/CIS_config.log 2>&1
echo "3.1.2 Retain appfirewall.log for 90 or more days"  >> ~/CIS_config.log 2>&1
sudo sed -r -i .bak 's/[= Facility com.apple.alf.logging] file appfirewall.log file_max=5M all_max=50M/> file appfirewall.log mode=0640 format=bsd rotate=utc compress file_max=5M ttl=90/g' /etc/asl.conf  >> ~/CIS_config.log 2>&1
echo "3.1.2 Retain appfirewall.log for 90 or more days - Complete"  >> ~/CIS_config.log 2>&1

#############################################################################
# 3.1.3 Retain authd.log for 90 or more days
#############################################################################
echo ""  >> ~/CIS_config.log 2>&1
echo "3.1.3 Retain authd.log for 90 or more days"  >> ~/CIS_config.log 2>&1
sudo sed -i .bak 's/file \/var\/log\/authd.log mode=0640 compress format=bsd rotate=seq file_max=5M all_max=20M/file \/var\/log\/authd.log mode=0640 format=bsd rotate=utc compress file_max=5M all_max=20M ttl=90/g' /etc/asl/com.apple.authd  >> ~/CIS_config.log 2>&1
echo "3.1.3 Retain authd.log for 90 or more days - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 3.2 Enable security auditing
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "3.2 Enable security auditing" >> ~/CIS_config.log 2>&1
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.auditd.plist >> ~/CIS_config.log 2>&1
echo "3.2 Enable security auditing - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 3.3 Configure Security Auditing Flags
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "3.3 Configure Security Auditing Flags" >> ~/CIS_config.log 2>&1
sudo sed -i .bak 's/[[:<:]]flags:lo,aa[[:>:]]/flags:lo,aa,ad,fd,fm,-all/g' /etc/security/audit_control >> ~/CIS_config.log 2>&1
echo "3.3 Configure Security Auditing Flags - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 3.3 Configure Security Auditing Flags
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "3.4 Enable remote logging for Desktops on trusted networks" >> ~/CIS_config.log 2>&1
echo "	This is disabled as there is no designated central log location" >> ~/CIS_config.log 2>&1
echo "3.4 Enable remote logging for Desktops on trusted networks - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 3.5 Retain install.log for 365 or more days
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "3.5 Retain install.log for 365 or more days" >> ~/CIS_config.log 2>&1
sudo sed -i .bak 's/file \/var\/log\/install.log format=bsd/file \/var\/log\/install.log mode=0640 format=bsd rotate=utc compress file_max=5M ttl=365/' /etc/asl/com.apple.install ~/CIS_config.log 2>&1
echo "3.5 Retain install.log for 365 or more days - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 4.1 Disable Bonjour advertising service
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "4.1 Disable Bonjour advertising service" >> ~/CIS_config.log 2>&1
if [[  $(sw_vers) ]]
then
	# MAKES SURE WE ARE RUNNING 10.6 -> 10.9 or 10.10.4+
	if [[  $(sw_vers -productVersion | grep '10.[6-9]') ]] || [[  $(sw_vers -productVersion | grep '10.10.4') ]]
	then
		# CHECKS FOR FLAG IN CURRENT PLIST FILE
		if [[ $(sudo /usr/libexec/PlistBuddy -c Print /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist | grep 'NoMulticast') ]]
		then
			echo "MULTICAST DISABLED, NO CHANGES MADE" >> ~/CIS_config.log 2>&1
		else
			sudo /usr/libexec/PlistBuddy -c "Add :ProgramArguments: string -NoMulticastAdvertisements" /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist >> ~/CIS_config.log 2>&1
			echo "MULTICAST DISABLED (OS X 10.6-10.9 or 10.10.4+), PLEASE REBOOT" >> ~/CIS_config.log 2>&1
		fi
		exit
	fi
fi
echo "4.1 Disable Bonjour advertising service - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 4.2 Enable "Show Wi-Fi status in menu bar"
#############################################################################
echo ""  >> ~/CIS_config.log 2>&1
echo "4.2 Enable 'Show Wi-Fi status in menu bar'"  >> ~/CIS_config.log 2>&1

for i in $(find /Users -type d -maxdepth 1)
do
  if [ "$i" = "/Users/Shared" ] || [ "$i" = "/Users" ]; then
    /bin/echo "Found '$i', ignored"  >> ~/CIS_config.log 2>&1
  else
    PREF=$i/Library/Preferences/com.apple.systemuiserver.plist
    /bin/echo "Checking user: '$i': "  >> ~/CIS_config.log 2>&1
    if [ -e $PREF ]; then
      /bin/echo "Found"
      EXTRAS=`defaults read $PREF menuExtras`
      echo "Current settings: $EXTRAS"  >> ~/CIS_config.log 2>&1
      echo $EXTRAS | grep -q "/System/Library/CoreServices/Menu Extras/Airport.menu"  >> ~/CIS_config.log 2>&1
      if [ $? -eq 0 ]; then
        /bin/echo "Found existing string, exiting"  >> ~/CIS_config.log 2>&1
        break  >> ~/CIS_config.log 2>&1
      else
        /bin/echo "Adding WiFi Status" && defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Airport.menu"  >> ~/CIS_config.log 2>&1
        /bin/echo "New Setting: " && sudo defaults read $PREF menuExtras  >> ~/CIS_config.log 2>&1
        /bin/echo "Adding value"  >> ~/CIS_config.log 2>&1
        ACCOUNT=`/bin/echo $i | cut -d'/' -f 3`
        echo $ACCOUNT
        sudo chown -Rv $ACCOUNT:staff $PREF  >> ~/CIS_config.log 2>&1
        /bin/echo "New Setting: " && sudo defaults read $PREF menuExtras  >> ~/CIS_config.log 2>&1
      fi
    fi
  fi
done
echo "4.2 Enable 'Show Wi-Fi status in menu bar' - Complete"  >> ~/CIS_config.log 2>&1

#############################################################################
# 4.4 Ensure http server is not running
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "4.4 Ensure http server is not running" >> ~/CIS_config.log 2>&1
sudo defaults write /System/Library/LaunchDaemons/org.apache.httpd Disabled -bool true
sudo defaults read /System/Library/LaunchDaemons/org.apache.httpd Disabled >> ~/CIS_config.log 2>&1
echo "4.4 Ensure http server is not running - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 4.5 Ensure ftp server is not running
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "4.5 Ensure ftp server is not running" >> ~/CIS_config.log 2>&1
sudo -s launchctl unload -w /System/Library/LaunchDaemons/ftp.plist >> ~/CIS_config.log 2>&1
echo "4.5 Ensure ftp server is not running - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 4.6 Ensure nfs server is not running
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "4.6 Ensure nfs server is not running" >> ~/CIS_config.log 2>&1
sudo nfsd disable >> ~/CIS_config.log 2>&1
sudo rm /etc/exports >> ~/CIS_config.log 2>&1
echo "4.6 Ensure nfs server is not running - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 5.1.2 Check System Wide Applications for appropriate permissions
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "5.1.2 Check System Wide Applications for appropriate permissions" >> ~/CIS_config.log 2>&1
sudo find /Applications -iname "*\.app" -type d -perm -2 -ls -exec chmod -R o-w {} \; >> ~/CIS_config.log 2>&1
echo "5.1.2 Check System Wide Applications for appropriate permissions - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 5.1.3 Check System folder for world writable files
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "5.1.3 Check System folder for world writable files" >> ~/CIS_config.log 2>&1
echo "	Maunal check needs to be done" 2>&1
echo "5.1.3 Check System folder for world writable files - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 5.1.4 Check Library folder for world writable files
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "5.1.4 Check Library folder for world writable files" >> ~/CIS_config.log 2>&1
echo "	Before:" >> ~/CIS_config.log 2>&1
sudo find /Library -type d -perm -2 -ls >> ~/CIS_config.log 2>&1
sudo find /Library -type d -perm -2 -ls -exec chmod -R o-w {} \; >> ~/CIS_config.log 2>&1
echo "	After:" >> ~/CIS_config.log 2>&1
sudo find /Library -type d -perm -2 -ls >> ~/CIS_config.log 2>&1
echo "5.1.4 Check Library folder for world writable files - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 5.2 Password Management - All Configuration Items
#	https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man8/pwpolicy.8.html
#	http://krypted.com/mac-os-x/programatically-setting-password-policies/
#	Be at least 8 characters long
#	Contain at least one upper-case alphabetic character
#	Have at least one lower-case alphabetic character
#	Have at least one numeric character
#	Have at least one special character (e.g. ~ ! @ # $ % ^ & * ( ) _ + = - ' [ ] / ? > <)
#	Max failed login attempts = 5
#	Password Expiration = 180 days (259200 seconds)
#	Minutes Until Failed Authentication Reset = 5
#	Can change own password
#	Password cannot be Name
#############################################################################
#echo "" >> ~/CIS_config.log 2>&1
#echo "5.2 Password Management - All Configuration Items" >> ~/CIS_config.log 2>&1
sudo pwpolicy -n /Local/Default -setglobalpolicy "minChars=8 requiresAlpha=1 requiresNumeric=1 minimumSymbols=1 requiresMixedCase=1 notGuessablePattern=0 canModifyPasswordforSelf=1 maxFailedLoginAttempts=5 MaximumFailedAuthentications=5 passwordCannotBeName=1 maxMinutesUntilChangePassword=259200 PasswordHistoryDepth=24 MaximumConsecutiveCharacters=4 MaximumSequentialCharacters=4 ExpiresEveryNDays=180"
sudo pwpolicy -getaccountpolicies >> ~/CIS_config.log 2>&1
echo "5.2 Password Management - All Configuration Items - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 5.3 Reduce the sudo timeout period
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "5.3 Reduce the sudo timeout period" >> ~/CIS_config.log 2>&1
echo "	This has to be performed manually" >> ~/CIS_config.log 2>&1
echo "	Open a Terminal and type 'sudo visudo'" >> ~/CIS_config.log 2>&1
echo "	Add the following line to the end of the file:" >> ~/CIS_config.log 2>&1
echo "		Defaults timestamp_timeout=0" >> ~/CIS_config.log 2>&1
echo "5.3 Reduce the sudo timeout period - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 5.4 Automatically lock the login keychain for inactivity
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "5.4 Automatically lock the login keychain for inactivity" >> ~/CIS_config.log 2>&1
echo "	This has to be performed manually" >> ~/CIS_config.log 2>&1
echo "	Open Applications | Utilities" >> ~/CIS_config.log 2>&1

echo "	Select Keychain Access" >> ~/CIS_config.log 2>&1
echo "	Select a keychain" >> ~/CIS_config.log 2>&1
echo "	Select Edit" >> ~/CIS_config.log 2>&1
echo "	Select Change Settings for keychain <keychain_name>" >> ~/CIS_config.log 2>&1
echo "	Authenticate, if requested." >> ~/CIS_config.log 2>&1
echo "	Change the Lock after # minutes of inactivity setting for the Login Keychain to 3600 minutes." >> ~/CIS_config.log 2>&1
echo "5.4 Automatically lock the login keychain for inactivity - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 5.5 Ensure login keychain is locked when the computer sleeps
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "5.5 Ensure login keychain is locked when the computer sleeps" >> ~/CIS_config.log 2>&1
echo "	This has to be performed manually" >> ~/CIS_config.log 2>&1
echo "	Open Applications | Utilities" >> ~/CIS_config.log 2>&1

echo "	Select Keychain Access" >> ~/CIS_config.log 2>&1
echo "	Select a keychain" >> ~/CIS_config.log 2>&1
echo "	Select Edit" >> ~/CIS_config.log 2>&1
echo "	Select Change Settings for keychain <keychain_name>" >> ~/CIS_config.log 2>&1
echo "	Authenticate, if requested." >> ~/CIS_config.log 2>&1
echo "	Select Lock when Sleeping setting" >> ~/CIS_config.log 2>&1
echo "5.5 Ensure login keychain is locked when the computer sleeps - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 5.6 Enable OCSP and CRL certificate checking
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "5.6 Enable OCSP and CRL certificate checking" >> ~/CIS_config.log 2>&1
for f in /Users/*;
        do
			if [ -d "$f" ]; then
				if [ "$f" == "/Users/Shared" ]; then
						/bin/echo "Found $f, ignored" >> ~/CIS_config.log 2>&1
				else
						[ -d $f ] && sudo cd "$f/Library/Preferences/" && echo Entering User Folder $f/Library/Preferences/ >> ~/CIS_config.log 2>&1
						sudo defaults write "$f/Library/Preferences/com.apple.security.revocation" OCSPStyle -string RequireIfPresent
						sudo defaults read "$f/Library/Preferences/com.apple.security.revocation" OCSPStyle >> ~/CIS_config.log 2>&1
						sudo defaults write "$f/Library/Preferences/com.apple.security.revocation" CRLStyle -string RequireIfPresent
						sudo defaults read "$f/Library/Preferences/com.apple.security.revocation" CRLStyle >> ~/CIS_config.log 2>&1
				fi
			fi
        done;
echo "5.6 Enable OCSP and CRL certificate checking - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 5.7 Do not enable the "root" account
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "5.7 Do not enable the 'root' account" >> ~/CIS_config.log 2>&1
dscl . -read /Users/root AuthenticationAuthority  >> ~/CIS_config.log 2>&1
echo "5.7 Do not enable the 'root' account - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 5.8 Disable automatic login
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "5.8 Disable automatic login" >> ~/CIS_config.log 2>&1
for f in /Users/*;
        do
			if [ -d "$f" ]; then
				if [ "$f" == "/Users/Shared" ]; then
						/bin/echo "Found $f, ignored"
				else
						[ -d $f ] && sudo cd "$f/Library/Preferences/" && echo Entering User Folder $f/Library/Preferences/ >> ~/CIS_config.log 2>&1
						echo "Before: " >> ~/CIS_config.log 2>&1
						sudo defaults read "$f/Library/Preferences/com.apple.loginwindow" >> ~/CIS_config.log 2>&1
						sudo defaults delete "$f/Library/Preferences/com.apple.loginwindow" autoLoginUser
						echo "After: " >> ~/CIS_config.log 2>&1
						sudo defaults read "$f/Library/Preferences/com.apple.loginwindow" >> ~/CIS_config.log 2>&1
				fi
			fi
        done;
echo "5.8 Disable automatic login - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 5.9 Require a password to wake the computer from sleep or screen saver
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "5.9 Require a password to wake the computer from sleep or screen saver" >> ~/CIS_config.log 2>&1
for f in /Users/*;
        do
                if [ -d "$f" ]; then
                        if [ "$f" == "/Users/Shared" ]; then
                                /bin/echo "Found $f, ignored"
                        else
                                [ -d $f ] && sudo cd "$f/Library/Preferences/" && echo Entering User Folder $f/Library/Preferences/ >> ~/CIS_config.log 2>&1
                                sudo defaults write "$f/Library/Preferences/com.apple.screensaver" askForPassword -bool true
								sudo defaults read "$f/Library/Preferences/com.apple.screensaver" askForPassword >> ~/CIS_config.log 2>&1
                        fi
                fi
        done;
echo "5.9 Require a password to wake the computer from sleep or screen saver - Complete" >> ~/CIS_config.log 2>&1


#############################################################################
# 5.10 Require an administrator password to access system-wide preferences
#############################################################################
echo ""  >> ~/CIS_config.log 2>&1
echo "5.10 Require an administrator password to access system-wide preferences"  >> ~/CIS_config.log 2>&1
echo "Reading values to a backup file"  >> ~/CIS_config.log 2>&1
sudo security authorizationdb read system.preferences > /tmp/system.preferences.plist.backup
echo "Reading values to /tmp to modify"  >> ~/CIS_config.log 2>&1
sudo security authorizationdb read system.preferences > /tmp/system.preferences.right.plist
echo "Reading values from /tmp"  >> ~/CIS_config.log 2>&1
sudo chmod 777 /tmp/system.preferences.right.plist
sudo defaults read /tmp/system.preferences.right.plist  >> ~/CIS_config.log 2>&1
echo "Modifying value in /tmp file"  >> ~/CIS_config.log 2>&1
sudo defaults write /tmp/system.preferences.right.plist shared -bool false
echo "Changing permissions on /tmp file"  >> ~/CIS_config.log 2>&1
sudo chmod 777 /tmp/system.preferences.right.plist  >> ~/CIS_config.log 2>&1
echo "Reading new values in /tmp file"  >> ~/CIS_config.log 2>&1
sudo defaults read /tmp/system.preferences.right.plist  >> ~/CIS_config.log 2>&1
echo "Writing value back to authorizationdb"  >> ~/CIS_config.log 2>&1
sudo security authorizationdb write system.preferences < /tmp/system.preferences.right.plist  >> ~/CIS_config.log 2>&1
echo "Reading authorizationdb values again"  >> ~/CIS_config.log 2>&1
sudo security authorizationdb read system.preferences  >> ~/CIS_config.log 2>&1
echo "5.10 Require an administrator password to access system-wide preferences - Complete"  >> ~/CIS_config.log 2>&1

#############################################################################
# 5.11 Disable ability to login to another user's active and locked session
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "5.11 Disable ability to login to another user's active and locked session" >> ~/CIS_config.log 2>&1
echo "	Before change:" >> ~/CIS_config.log 2>&1
sudo cat /etc/pam.d/screensaver >> ~/CIS_config.log 2>&1
sudo find /etc/pam.d/ -type f -name 'screensaver' -exec sed -i .bak 's/pam_group.so no_warn group=admin,wheel fail_safe/pam_group.so no_warn group=wheel fail_safe/' {} +
echo "	After change:" >> ~/CIS_config.log 2>&1
sudo cat /etc/pam.d/screensaver >> ~/CIS_config.log 2>&1
echo "5.11 Disable ability to login to another user's active and locked session - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 5.12 Create a custom message for the Login Screen
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "5.12 Create a custom message for the Login Screen" >> ~/CIS_config.log 2>&1
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "***** WARNING  ***  WARNING  ***  WARNING *****
You are accessing a U.S. Government information system
***** WARNING  ***  WARNING  ***  WARNING *****"
sudo defaults read /Library/Preferences/com.apple.loginwindow LoginwindowText >> ~/CIS_config.log 2>&1
echo "5.12 Create a custom message for the Login Screen - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 5.13 Create a Login window banner
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "5.13 Create a Login window banner" >> ~/CIS_config.log 2>&1
echo "***** WARNING  ***  WARNING  ***  WARNING *****" >> /tmp/PolicyBanner.txt
echo "\nYou are accessing a U.S. Government information system, which includes this computer, the computer network on which it is connected, all other computers connected to this network, and all storage media connected to this computer or other computers on this network. This information system is provided for U.S Government use only. Unauthorized or improper use of this information may result in disciplinary action, as well as civil and criminal penalties. By using this information system you consent to the following" >> /tmp/PolicyBanner.txt
echo "\na. You have no reasonable expectation of privacy regarding any communications or data transiting this network or stored in this information system" >> /tmp/PolicyBanner.txt
echo "\nb. At any time, and for any lawful government purpose, the government may monitor, intercept, search and seize any communication or data transiting or stored on this information system and" >> /tmp/PolicyBanner.txt
echo "\nc. Any communication or data transiting or stored on this information system may be disclosed or used for any lawful government purpose." >> /tmp/PolicyBanner.txt
echo "\n***** WARNING  ***  WARNING  ***  WARNING *****" >> /tmp/PolicyBanner.txt
sudo cp /tmp/PolicyBanner.txt /Library/Security
sudo chmod o+r /Library/Security/PolicyBanner.txt
rm /tmp/PolicyBanner.txt
cat /Library/Security/PolicyBanner.txt >> ~/CIS_config.log 2>&1
echo "5.13 Create a Login window banner" >> ~/CIS_config.log 2>&1

#############################################################################
# 5.15 Disable Fast User Switching
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "5.15 Disable Fast User Switching" >> ~/CIS_config.log 2>&1
sudo defaults write /Library/Preferences/.GlobalPreferences MultipleSessionEnabled -bool false
sudo defaults read /Library/Preferences/.GlobalPreferences MultipleSessionEnabled >> ~/CIS_config.log 2>&1
echo "5.15 Disable Fast User Switching - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 5.18 System Integrity Protection status
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "5.18 System Integrity Protection status" >> ~/CIS_config.log 2>&1
/usr/bin/csrutil status >> ~/CIS_config.log 2>&1
echo "5.18 System Integrity Protection status - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 5.19 Install an approved tokend for smartcard authentication
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "5.19 Install an approved tokend for smartcard authentication" >> ~/CIS_config.log 2>&1
echo "	This is addressed by the installation of the following:" >> ~/CIS_config.log 2>&1
echo "		Centrify Smartcard Reader" >> ~/CIS_config.log 2>&1
echo "		OpenSC for MacOS" >> ~/CIS_config.log 2>&1
ls -l /Library/Security/tokend/ | egrep tokend >> ~/CIS_config.log 2>&1
echo "5.19 Install an approved tokend for smartcard authentication - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 6.1.1 Display login window as name and password
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "6.1.1 Display login window as name and password" >> ~/CIS_config.log 2>&1
sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true
defaults read /Library/Preferences/com.apple.loginwindow SHOWFULLNAME >> ~/CIS_config.log 2>&1
echo "6.1.1 Display login window as name and password - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 6.1.2 Disable "Show Password Hints"
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "6.1.2 Disable 'Show Password Hints'" >> ~/CIS_config.log 2>&1
sudo defaults write /Library/Preferences/com.apple.loginwindow RetriesUntilHint -int 0
defaults read /Library/Preferences/com.apple.loginwindow RetriesUntilHint >> ~/CIS_config.log 2>&1
echo "6.1.2 Disable 'Show Password Hints' - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 6.1.4 Disable "Allow guests to connect to shared folders"
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "6.1.4 Disable 'Allow guests to connect to shared folders'" >> ~/CIS_config.log 2>&1
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool false
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool false
sudo defaults read /Library/Preferences/com.apple.AppleFileServer guestAccess >> ~/CIS_config.log 2>&1
sudo defaults read /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess >> ~/CIS_config.log 2>&1
echo "6.1.4 Disable 'Allow guests to connect to shared folders' - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 6.1.5 Remove Guest home folder
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "6.1.5 Remove Guest home folder" >> ~/CIS_config.log 2>&1
sudo rm -rf /Users/Guest >> ~/CIS_config.log 2>&1
echo "6.1.5 Remove Guest home folder - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 6.2 Turn on filename extensions
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "6.2 Turn on filename extensions" >> ~/CIS_config.log 2>&1
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults read NSGlobalDomain AppleShowAllExtensions >> ~/CIS_config.log 2>&1
echo "6.2 Turn on filename extensions - Complete" >> ~/CIS_config.log 2>&1

#############################################################################
# 6.3 Disable the automatic run of safe files in Safari
#############################################################################
echo ""  >> ~/CIS_config.log 2>&1
echo "6.3 Disable the automatic run of safe files in Safari"  >> ~/CIS_config.log 2>&1
for i in $(find /Users -type d -maxdepth 1)
do
  /bin/echo $i
  if [ "$i" = "/Users/Shared" ] || [ "$i" = "/Users" ]; then
    /bin/echo "Found '$i', ignored"
    /bin/echo "Found '$i', ignored"  >> ~/CIS_config.log 2>&1
  else
    PREF=$i/Library/Preferences/com.apple.Safari.plist
    /bin/echo $PREF
    /bin/echo "Checking user: '$i': "
    if [ -e $PREF ]; then
      /bin/echo "Found"
        /bin/echo "Current Setting: " && sudo defaults read $PREF AutoOpenSafeDownloads  >> ~/CIS_config.log 2>&1
        /bin/echo "Adding Value" && sudo defaults write $PREF AutoOpenSafeDownloads -bool false
        ACCOUNT=`/bin/echo $i | cut -d'/' -f 3`
        echo $ACCOUNT
        sudo chown -Rv $ACCOUNT:staff $PREF  >> ~/CIS_config.log 2>&1
        /bin/echo "New Setting: " && sudo defaults read $PREF AutoOpenSafeDownloads  >> ~/CIS_config.log 2>&1
    else
      /bin/echo "File not found, creating file"  >> ~/CIS_config.log 2>&1
      sudo touch $i/Library/Preferences/com.apple.Safari.plist
      /bin/echo "Current Setting: " && sudo defaults read $PREF AutoOpenSafeDownloads  >> ~/CIS_config.log 2>&1
      /bin/echo "Adding Value" && sudo defaults write $PREF AutoOpenSafeDownloads -bool false  >> ~/CIS_config.log 2>&1
      ACCOUNT=`/bin/echo $i | cut -d'/' -f 3`
      echo $ACCOUNT
      sudo chown -Rv $ACCOUNT:staff $PREF  >> ~/CIS_config.log 2>&1
      /bin/echo "New Setting: " && sudo defaults read $PREF AutoOpenSafeDownloads  >> ~/CIS_config.log 2>&1
    fi
  fi
done
echo ""  >> ~/CIS_config.log 2>&1
echo "6.3 Disable the automatic run of safe files in Safari - Complete"  >> ~/CIS_config.log 2>&1

#############################################################################
# Resetting File Permissions
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "Resetting File Permissions" >> ~/CIS_config.log 2>&1
for f in /Users/*;
	do
		if [ "$f" == "Shared" ]; then
			/bin/echo "Found $f, ignored" >> ~/CIS_config.log 2>&1
		else
			echo "Checking User: '$f': " >> ~/CIS_config.log 2>&1
			ACCOUNT=`/bin/echo $f | cut -d'/' -f 3`
			echo $ACCOUNT
			sudo chown -Rv $ACCOUNT:staff $f/Library/Preferences/ByHost/ >> ~/CIS_config.log 2>&1
			sudo chown -Rv $ACCOUNT:staff $f/Library/Preferences/ >> ~/CIS_config.log 2>&1
		fi
	done;
echo "Resetting File Permissions - Complete" >> ~/CIS_config.log 2>&1


#############################################################################
# 5.1.1 Secure Home Folders
# (Placed at end of CIS to ensure other settings can be modified as this 
# will lock the ability to change some settings)
# To reverse: sudo chmod -R -N [Directory Path]
#############################################################################
echo "" >> ~/CIS_config.log 2>&1
echo "5.1.1 Secure Home Folders" >> ~/CIS_config.log 2>&1
sudo find /Users/ -type d -d 1 -not -path "/Users/Shared" -exec chmod -R og-rwx {} \; >> ~/CIS_config.log 2>&1
echo "5.1.1 Secure Home Folders - Complete" >> ~/CIS_config.log 2>&1
echo ""

#echo "Resourcing the bash profile"
#source ~/.bash_profile

end_ms=$(ruby -e 'puts (Time.now.to_f).to_i')
elapsed_ms=$((end_ms - start_ms))


echo "Done in $elapsed_ms seconds"
