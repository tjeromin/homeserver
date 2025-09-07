# Homeserver

Runs nextcloud, iobroker, influxdb and grafana in docker containers.

## Power Monitoring
The server monitors the power as shown below:

![SVG Image](images/PowerMonitoring.svg)

### tasmota (reads powermeter)
The powermeter is read via infra red by a microcontroller and sent to the network via mqtt and used by iobroker. 
The mqtt protocol has to be configured correctly.

This script has to be configured to read the powermeter:
```
>D
>B
=>sensor53 r
>M 1
+1,5,s,16,9600,DWS7420
1,77070100010800ff@1000,Energie,kWh,energy,4
1,77070100020800ff@1000,Lieferung,kWh,en_out,4
1,77070100100700ff@1,Leistung,W,power,2
1,7707010060320101@#,SID,,meter_id,0
#
```

## Installation and configuration

### Nextcloud

#### Update

To update nextcloud just change the tag in docker-compose.yaml to the next major version. Don't skip a major verison.

### MariaDB

#### Update

To update mariadb just change the tag in docker-compose.yaml to any higher version. MARIADB_AUTO_UPGRADE=1 has to be set. Don't remove the container.

### cronjobs
cronjobs must run contained in installation folder.

### fstab
fstab entries must be added to the fstab file on the host to mount the drives correctly.

### https

The domain is hosted by cloudflare. For https to work the go to Cloudflare -> SSL -> Overview -> Configure SSL/TLS Encryption -> Set mode to Full or Full (Strict).

#### Error message: Page isn't redirected properly
Follow steps above in cloudflare and make sure the caddyfile contains following sections:
```caddyfile
{
    # Set the ACME DNS challenge provider to use Cloudflare for all sites
    acme_dns cloudflare <dns api token>
}

...

example.org { ... }
```

### influxdb

#### setup

The API-TOKEN needs to be added to the environment variables under `/etc/environment`.

#### manipulate data
```
// Daten ändern in bestimmten Zeitraum

import "date"

option startTime = date.time(t: 2024-09-30T03:00:00Z)
option stopTime = date.time(t: 2024-10-05T12:00:00Z)

from(bucket: "smarthome")
  |> range(start: startTime, stop: stopTime)
  |> filter(fn: (r) => r["_measurement"] == "power")
  |> filter(fn: (r) => r["_field"] == "power")
  |> map(fn: (r) => ({ r with _value: 300 }))
  |> to(bucket: "test")
  
// Daten löschen in bestimmten Zeitraum

influx delete --org tino --bucket smarthome-history   --start '2024-10-05T13:00:00Z'   --stop '2024-10-06T20:00:00Z' --predicate '_measurement="power" AND device="smartmeter" AND _value=0' --token <api_token>
```