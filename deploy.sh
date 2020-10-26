docker build -t turmune/multi-client:latest -t turmune/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t turmune/multi-server:latest -t turmune/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t turmune/multi-worker:latest -t turmune/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push turmune/multi-client:latest
docker push turmune/multi-server:latest
docker push turmune/multi-worker:latest

docker push turmune/multi-client:$SHA
docker push turmune/multi-server:$SHA
docker push turmune/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=turmune/multi-server:$SHA
kubectl set image deployments/client-deployment client=turmune/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=turmune/multi-worker:$SHA