tagversion=v1.0_1
git reset --hard origin/master 
git pull 
chmod a+x onekey-docker.sh 
gradle clean && gradle build -x test 
docker build -t 10.19.13.18:5000/slp-product-web:${tagversion} .   
docker push 10.19.13.18:5000/slp-product-web:${tagversion} 

docker rmi aioptapp/slp-product-web:${tagversion}  
docker tag 10.19.13.18:5000/slp-product-web:${tagversion}  aioptapp/slp-product-web:${tagversion}  
docker login --username=aioptapp --password=aioptapp@123 --email=wuzhen3@asiainfo.com 
docker push aioptapp/slp-product-web:${tagversion}  