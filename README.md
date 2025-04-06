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
