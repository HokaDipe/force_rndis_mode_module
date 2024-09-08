#!/system/bin/sh
# Script to enable USB tethering automatically when USB is connected

# Wait for the system to be fully booted
until [ $(getprop sys.boot_completed) -eq 1 ]; do
    sleep 1
done
log -p i -t AutoTethering "System boot completed, starting tethering check loop."
sleep 3
while true; do   
	export PATH=/system/bin:$PATH
	log -p i -t AutoTethering "Using PATH: $PATH"
	usb_state1=$(getprop sys.usb.state)
    # Log current USB state
    log -p i -t AutoTethering "Current USB state: $usb_state1"
        if [[ "$usb_state1" != *"rndis"* ]] && [[ "$usb_state1" != *"mtp"* ]] ; then
			which svc >> /cache/auto_tethering_debug.log
			/system/bin/svc usb setFunctions rndis >> /cache/auto_tethering_debug.log 2>&1
            usb_state1=$(getprop sys.usb.state)  # Recheck USB state
			sleep 1
            log -p i -t AutoTethering "USB state after run code: $usb_state1"
			sleep 2
            if [[ "$usb_state1" = *"rndis"* ]]; then
                log -p i -t AutoTethering "Successfully to enabled."
            else
                log -p e -t AutoTethering "Failed to enable."
            fi
        else
    sleep 2  # Increase the sleep duration to reduce log spam
		log -p e -t AutoTethering "$usb_state1 mode is already using."	
	sleep 2
		fi
done
