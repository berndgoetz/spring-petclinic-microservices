start=$(date)
cf stop customers-service
cf stop visits-service
cf stop vets-service
cf stop api-gateway

cf us vets-service config
cf us vets-service registry
cf us customers-service config
cf us customers-service registry
cf us visits-service config
cf us visits-service registry
cf us api-gateway config
cf us api-gateway registry

cf d visits-service -f
cf d customers-service -f
cf d vets-service -f
cf d api-gateway -f

cf ds config -f
cf ds registry -f

cf ds visits-db -f
cf ds vets-db -f
cf ds customers-db -f

visitssvc=0
customerssvc=0
vetssvc=0
apigwsvc=0
visitsdb=0
customersdb=0
vetsdb=0
echo -n "Waiting for deletion..."
until [[ $visitsdb -eq 1 && $customersdb -eq 1 && $vetsdb -eq 1 && \
         $visitssvc -eq 1 && $customerssvc -eq 1 && vetssvc -eq 1 && apigwsvc -eq 1 ]]; do
  echo -n "."
  cf service visits-db &> /dev/null; visitsdb=$?
  cf service customers-db &> /dev/null; customersdb=$?
  cf service vets-db &> /dev/null; vetsdb=$?
  cf app customers-service &> /dev/null; customerssvc=$?
  cf app vets-service &> /dev/null; vetssvc=$?
  cf app visits-service &> /dev/null; visitssvc=$?
  cf app api-gateway &> /dev/null; apigwsvc=$?
done
echo done
echo Start: $start
echo End:   $(date)
