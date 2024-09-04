# monitor-ocmirror


## Overview

The `oc-mirror v1` tool can be demanding on the network, and it may sometimes fail with an error like “unauthorized: Access to the requested resource is not authorized” after mirroring for a while. In such cases, simply restarting the command often resolves the issue and allows it to continue from where it left off.

## Monitor-ocmirror Script

The `monitor-ocmirror` script is designed to run the `oc-mirror` command and restart it depending on the reason for its failure.

### How It Works

1. **Edit the Script**
2. **Update the Following Variables**

   ```bash
   # Log file name
   LOGFILE="<log file name>"

   # The oc-mirror command
   LAUNCH="<oc mirror command>"

   # The maximum number of restarts
   MAXLOOP=20

3. **Run the script**

   ```bash
   ./monitor-ocmirror.sh
