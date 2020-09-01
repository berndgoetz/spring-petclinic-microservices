start=$(date)
echo -n "Creating Required Services..."
{
  cf create-service \
    -c '{ "git": { "uri": "https://github.com/odedia/spring-petclinic-microservices-config.git", "periodic": true }, "count": 1 }' \
    p.config-server standard config &
  cf create-service p.service-registry standard registry &
  cf create-service p.mysql db-small customers-db &
  cf create-service p.mysql db-small vets-db &
  cf create-service p.mysql db-small visits-db &
  sleep 5
} &> /dev/null
until [ `cf service config | grep -c "succeeded"` -ge 1  ] && \
      [ `cf service registry | grep -c "succeeded"` -ge 1  ] && \
      [ `cf service customers-db | grep -c "succeeded"` -ge 1  ] && \
      [ `cf service vets-db | grep -c "succeeded"` -ge 1  ] && \
      [ `cf service visits-db | grep -c "succeeded"` -ge 1  ]
do
  echo -n "."
done

mvn clean package -Pcloud -DskipTests
cf push --no-start

cf add-network-policy api-gateway --destination-app vets-service --protocol tcp --port 8080
cf add-network-policy api-gateway --destination-app customers-service --protocol tcp --port 8080
cf add-network-policy api-gateway --destination-app visits-service --protocol tcp --port 8080

echo -n "Starting services..."
{
  cf start vets-service &
  cf start visits-service &
  cf start customers-service &
  cf start api-gateway &
} &> /dev/null
until [ `cf app vets-service | grep -c "running"` -ge 1  ] && \
      [ `cf app visits-service | grep -c "running"` -ge 1  ] && \
      [ `cf app customers-service | grep -c "running"` -ge 1  ] && \
      [ `cf app api-gateway | grep -c "running"` -ge 1  ]
do
  echo -n "."
done
echo done
echo Start: $start
echo End:   $(date)
