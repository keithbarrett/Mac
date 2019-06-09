#!/bin/bash

# IMPORTANT: You will need to disable SIP aka Rootless in order to fully execute this script, you can reenable it after.
# WARNING: It might disable things that you may not like. Please double check the services in the TODISABLE vars.

# Get active services: launchctl list | grep -v "\-\t0"
# Find a service: grep -lR [service] /System/Library/Launch* /Library/Launch* ~/Library/LaunchAgents

# This script shuts down the service and renames it's plist file to plist-orig. Running this script with the first
# argument as "ENABLED" will re-enable the services, provided that the "plist-orig" files are still intact. After
# running this script you will need to reboot the system, as running services will not necessarily be stopped.

###
###
### AGENTS to disable
###


DAEMONS=()
#Uncommented means delete service

#DAEMONS+=('com.apple.AirPlayXPCHelper')  # Airplay daemon
DAEMONS+=('com.apple.AirPlayUIAgent')  # Airplay
DAEMONS+=("com.apple.AirPortBaseStationAgent")  # Airplay
DAEMONS+=('com.apple.AOSPushRelay')  # AOS Push Relay
DAEMONS+=('com.apple.appleseed.seedusaged')
DAEMONS+=('com.apple.assistantd')
DAEMONS+=('com.apple.assistant_service')
DAEMONS+=('com.apple.CalendarAgent')  # Calendar App
DAEMONS+=('com.apple.CallHistorySyncHelper')
DAEMONS+=('com.apple.CallHistoryPluginHelper')
DAEMONS+=('com.apple.cloudd')
### DAEMONS+=('com.apple.cloudfamilyrestrictionsd-mac')  ### Missing on Mojave or High Sierra
DAEMONS+=('com.apple.cloudpaird')
DAEMONS+=('com.apple.cloudphotosd')
DAEMONS+=('com.apple.CommCenter-osx')
DAEMONS+=('com.apple.DictationIM')
DAEMONS+=('com.apple.familycircled')
DAEMONS+=('com.apple.familycontrols.useragent')
DAEMONS+=('com.apple.familynotificationd')
DAEMONS+=('com.apple.findmymacmessenger')  # Related to find my mac daemon, propacommands sent through FindMyDevice in iCloud
DAEMONS+=('com.apple.gamed')
### DAEMONS+=('com.apple.geodMachServiceBridge')  ### Not on Mojave or High Sierra
#DAEMONS+=('com.apple.icloud.findmydeviced.findmydevice-user-agent')  # Related to find-my-mac
DAEMONS+=('com.apple.icloud.fmfd')
DAEMONS+=('com.apple.iCloudUserNotifications')  # Related to iCloud
#DAEMONS+=('com.apple.identityservicesd')  # Network will appear empty if disabled
DAEMONS+=('com.apple.imagent')
### DAEMONS+=('com.apple.IMLoggingAgent')  ### Not on Mojave
### DAEMONS+=('com.apple.Maps.mapspushd')  ### Not on Mojave or High Sierra
DAEMONS+=('com.apple.Maps.pushdaemon')
DAEMONS+=('com.apple.parentalcontrols.check')
DAEMONS+=('com.apple.parsecd')
DAEMONS+=('com.apple.personad')
DAEMONS+=('com.apple.photoanalysisd')
DAEMONS+=('com.apple.SafariCloudHistoryPushAgent')  # Disable to Speed up Safari
#DAEMONS+=('com.apple.screensharing.MessagesAgent')  # Screen Sharing
DAEMONS+=('com.apple.security.cloudkeychainproxy3')
### DAEMONS+=('com.apple.security.idskeychainsyncingproxy')  ### Not in Mojave or High Sierra
DAEMONS+=('com.apple.security.keychain-circle-notification')
#DAEMONS+=('com.apple.sharingd')  # sharing?
DAEMONS+=('com.apple.syncdefaultsd')
DAEMONS+=('com.apple.telephonyutilities.callservicesd')
DAEMONS+=('com.apple.touristd')

for agent in "${DAEMONS[@]}"
do
    if [ "$1" == "ENABLE" ]
    then
        if [ ! -f /System/Library/LaunchAgents/${agent}.plist-orig ]
        then
            echo "[SKIPPED] Agent ${agent} plist backup missing"
        else
	    sudo mv -f /System/Library/LaunchAgents/${agent}.plist-orig /System/Library/LaunchAgents/${agent}.plist
	    {
                sudo launchctl load -w /System/Library/LaunchAgents/${agent}.plist
                launchctl load -w /System/Library/LaunchAgents/${agent}.plist
	    } &> /dev/null
	    echo "[OK]  Agent ${agent} ENABLED and launched"
        fi

    else
        if [ -f /System/Library/LaunchAgents/${agent}.plist-orig ]
        then
            echo "[SKIPPED] Agent ${agent} plist already moved"
        elif [ -f /System/Library/LaunchAgents/${agent}.plist ]
        then
	    {
                sudo launchctl unload -w /System/Library/LaunchAgents/${agent}.plist
                launchctl unload -w /System/Library/LaunchAgents/${agent}.plist
	    } &> /dev/null
	    sudo mv -f /System/Library/LaunchAgents/${agent}.plist /System/Library/LaunchAgents/${agent}.plist-orig
	    echo "[OK]  Agent ${agent} disabled"
        else
	    echo "[BAD] Agent ${agent} plist not found"
        fi
    fi
done


###
###
### DAEMONs to Disable
###

DAEMONS=()
#Uncommented means delete service

### DAEMONS+=('com.apple.AOSNotificationOSX')  # AOS Notifications ### Missing on Mojave and High Sierra
DAEMONS+=('com.apple.appleseed.fbahelperd')  # Related to feedback
DAEMONS+=('com.apple.apsd')  # Apple Push Notify Service (apsd) - Calls home quite often. Rsed by Facetime and Messages
#DAEMONS+=('com.apple.awacsd')  # Apple Wide Area Connectivity Service daemon - Back to My Mac Feature
DAEMONS+=('com.apple.awdd')  # Sending out diagnostics & usage
DAEMONS+=('com.apple.CrashReporterSupportHelper')  # Crash reporter
#DAEMONS+=('com.apple.eapolcfg_auth')  # Perform privileged operations required by certain EAPOLClientConfiguration.h APIs
DAEMONS+=('com.apple.familycontrols')  # Parent control
### DAEMONS+=('com.apple.FileSyncAgent.sshd')  # Mostlikely sshd on this machine  ### Not in Mojave or High Sierra
#DAEMONS+=('com.apple.findmymac')  # Find my mac daemon
DAEMONS+=('com.apple.findmymacmessenger')
#DAEMONS+=('com.apple.icloud.findmydeviced')  # Related to find-my-mac
### DAEMONS+=('com.apple.iCloudStats')  # Related to iCloud  ### Not on Mojave and High Sierra
### DAEMONS+=('com.apple.laterscheduler')  # Schedule something?  ### Not in Mojave or High Sierra
DAEMONS+=('com.apple.locationd')  # Propably reading current location (needed by find my mac)
#DAEMONS+=('com.apple.ManagedClient.cloudconfigurationd')  # Related to manage current macOS user iCloud
#DAEMONS+=('com.apple.ManagedClient.enroll')  # Related to manage current macOS user
#DAEMONS+=('com.apple.ManagedClient.startup')  # Related to manage current macOS user
#DAEMONS+=('com.apple.ManagedClient')  # Related to manage current macOS user
### DAEMONS+=('com.apple.mbicloudsetupd')  # iCloud Settings  ### Not on Mojave and High Sierra
DAEMONS+=('com.apple.netbiosd')  # Netbiosd is microsoft's networking service. used to share files between mac and windows
#DAEMONS+=('com.apple.preferences.timezone.admintool')  # Time setting daemon
### DAEMONS+=('com.apple.preferences.timezone.auto')  # Time setting daemon  ### Not in Mojave or High Sierra
DAEMONS+=('com.apple.remotepairtool')  # Pairing devices remotely
DAEMONS+=('com.apple.rpmuxd')  # daemon for remote debugging of mobile devices.
#DAEMONS+=('com.apple.screensharing')  # Screen Sharing daemon
#DAEMONS+=('com.apple.security.FDERecoveryAgent')  # Full Disk Ecnryption - Related to File Vault https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man8/FDERecoveryAgent.8.html
DAEMONS+=('com.apple.SubmitDiagInfo')  # Feedback - most likely it submits your computer data when click 'About this mac'
#DAEMONS+=('com.apple.trustd')  # Propably related to certificates

echo ''

for daemon in "${DAEMONS[@]}"
do
    if [ "$1" == "ENABLE" ]
    then
        if [ ! -f /System/Library/LaunchDaemons/${daemon}.plist-orig ]
        then
            echo "[SKIPPED] Daemon ${daemon} plist backup missing"
        else
	    sudo mv -f /System/Library/LaunchDaemons/${daemon}.plist-orig /System/Library/LaunchDaemons/${daemon}.plist
	    {
                sudo launchctl load -w /System/Library/LaunchDaemons/${daemon}.plist
                launchctl load -w /System/Library/LaunchDaemons/${daemon}.plist
	    } &> /dev/null
	    echo "[OK]  Daemon ${agent} ENABLED and launched"
        fi

    else
        if [ -f /System/Library/LaunchDaemons/${daemon}.plist-orig ]
        then
            echo "[SKIPPED] Daemon ${daemon} plist already moved"
        elif [ -f /System/Library/LaunchDaemons/${daemon}.plist ]
        then
           {
              sudo launchctl unload -w /System/Library/LaunchDaemons/${daemon}.plist
              launchctl unload -w /System/Library/LaunchDaemons/${daemon}.plist
           } &> /dev/null
           sudo mv -f /System/Library/LaunchDaemons/${daemon}.plist /System/Library/LaunchDaemons/${daemon}.plist-orig
           echo "[OK]  Daemon ${daemon} disabled"
        else
        echo "[BAD] Daemon ${daemon} plist not found"
        fi
    fi
done
