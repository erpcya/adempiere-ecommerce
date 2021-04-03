# eCommerce Docker

<div align="center"><img src="https://camo.githubusercontent.com/911c5d54ded447403e56de3f96f332c06bceb8bd/68747470733a2f2f75706c6f61642e77696b696d656469612e6f72672f77696b6970656469612f636f6d6d6f6e732f622f62312f4164656d70696572652d6c6f676f2e706e67" style="text-align:center;" width="400" /></div>

### For all enviroment you should run the follow images:

- ADempiere gRPC: https://hub.docker.com/r/erpya/adempiere-grpc-all-in-one
```shell
docker pull erpya/adempiere-grpc-all-in-one
```

- Proxy ADempiere API: https://hub.docker.com/r/erpya/proxy-adempiere-api
```shell
docker pull erpya/proxy-adempiere-api
```

Run the latest container with: https://hub.docker.com/r/erpya/adempiere-ecommerce
```shell
    docker pull erpya/adempiere-ecommerce
```

```shell
docker run -it -d \
    --name eCommerce-ADempiere \
    -p 3000:3000 \
    -e "API_URL=http:\/\/localhost:8085" \
    -e "SERVER_PORT=3000" \
    -e "VS_ENV=prod" \
    erpya/adempiere-ecommerce
```
