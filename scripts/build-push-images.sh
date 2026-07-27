#!/bin/bash

set -e

REGISTRY="cr.yandex/crps7usnpsm729ptcit7"
TAG="v1.0.0"

docker build -t ${REGISTRY}/adservice:${TAG} ./src/adservice
docker build -t ${REGISTRY}/cartservice:${TAG} ./src/cartservice/src
docker build -t ${REGISTRY}/checkoutservice:${TAG} ./src/checkoutservice
docker build -t ${REGISTRY}/currencyservice:${TAG} ./src/currencyservice
docker build -t ${REGISTRY}/emailservice:${TAG} ./src/emailservice
docker build -t ${REGISTRY}/frontend:${TAG} ./src/frontend
docker build -t ${REGISTRY}/paymentservice:${TAG} ./src/paymentservice
docker build -t ${REGISTRY}/productcatalogservice:${TAG} ./src/productcatalogservice
docker build -t ${REGISTRY}/recommendationservice:${TAG} ./src/recommendationservice
docker build -t ${REGISTRY}/shippingservice:${TAG} ./src/shippingservice
docker build -t ${REGISTRY}/shoppingassistantservice:${TAG} ./src/shoppingassistantservice


docker push ${REGISTRY}/adservice:${TAG}
docker push ${REGISTRY}/cartservice:${TAG}
docker push ${REGISTRY}/checkoutservice:${TAG}
docker push ${REGISTRY}/currencyservice:${TAG}
docker push ${REGISTRY}/emailservice:${TAG}
docker push ${REGISTRY}/frontend:${TAG}
docker push ${REGISTRY}/paymentservice:${TAG}
docker push ${REGISTRY}/productcatalogservice:${TAG}
docker push ${REGISTRY}/recommendationservice:${TAG}
docker push ${REGISTRY}/shippingservice:${TAG}
docker push ${REGISTRY}/shoppingassistantservice:${TAG}