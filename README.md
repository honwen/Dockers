# Docker IPSEC L2TP VPN client

Docker earley-stage image to run an IPsec VPN client, with IPsec/L2TP, based on : https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/docs/clients.md

## HOW TO

After cloning the repo build docker image with the command

```bash
docker build -t chenhw2/ipsec-client .
```

In order to run the container the following environment variables need to be passed:

- `VPN_IPSEC_PSK`, `VPN_USER`, `VPN_PASSWORD` provided from your VPN provider
- the provider's ADDR is passed as `VPN_SERVER_ADDR`
- and the local-net cat be passed as well, named `VPN_LOCAL_GW_NET`

Then container launch would look like:

```conf
# ipsec.env
VPN_SERVER_ADDR=example.ipsec.net
VPN_IPSEC_PSK=psk
VPN_USER=user
VPN_PASSWORD=password
VPN_LOCAL_GW_NET=172.16.0.0/12
```

```bash
docker run --rm --name ipsec-client --env-file=ipsec.env --privileged -v=/lib/modules:/lib/modules:ro -p=8080:8080 chenhw2/ipsec-client
```

Test:

```bash
curl -x 127.0.0.1:8080 -v myip.ipip.net
```
