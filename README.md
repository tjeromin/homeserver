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
