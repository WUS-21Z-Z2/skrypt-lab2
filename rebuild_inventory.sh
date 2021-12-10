PUBLIC_IPS=$(gcloud compute instances list --format="value(networkInterfaces[0].networkIP,networkInterfaces[0].accessConfigs[0].natIP)" \
    | sort | awk '{ print $2 }' | grep -P '\S')

echo "all:" > ansible-inv.yml
echo "    hosts:" >> ansible-inv.yml

echo "$PUBLIC_IPS" | while read IP
do
    echo "        $IP:" >> ansible-inv.yml
done
