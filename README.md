# xray-abasthan

Xray (VLESS + WebSocket) running on an Abasthan free-tier Web Service, used as a
personal VPN node.

- Inbound: VLESS over WebSocket, path `/vless`, listening on `$PORT`
- The client UUID is supplied through the `UUID` environment variable in the
  Abasthan dashboard, never committed to this repo.
- TLS is terminated by Abasthan at the `*.abasthan.app` subdomain; Xray itself
  serves plain WebSocket behind it.

Client (v2rayNG): `vless://<UUID>@<subdomain>:443?encryption=none&security=tls&sni=<subdomain>&type=ws&path=%2Fvless#Abasthan`
