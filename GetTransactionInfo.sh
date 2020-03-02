#sudo apt-get install jq

read -p 'Enter Name of Contract: ' contract_name
read -p 'Enter Start DTG  (ISO8601): ' start_dtg
read -p 'Enter End DTG  (ISO8601):'  end_dtg

let cpu
let net
let limit=100000000

end="$(date -d "$end_dtg" +"%H:%M:%S %Y-%m-%d")"
start="$(date -d "$start_dtg" +"%H:%M:%S %Y-%m-%d")"

while [ "$start" != "$end" ]; do
        
        start1="$(date -d"$start + 30 minutes" +"%H:%M:%S %Y-%m-%d")"
        a="$(date -d "$start" +"%Y-%m-%dT%H:%M:%S")"
        b="$(date -d "$start1" +"%Y-%m-%dT%H:%M:%S")"
        
        #curl -X GET "https://junglehistory.cryptolions.io/v2/history/get_actions?filter=$contract_name%3A%2A&limit=$limit&after=$a&before=$b| jq '.actions[]'"
        get_transaction="$(curl -X GET "https://junglehistory.cryptolions.io/v2/history/get_actions?filter=$contract_name%3A%2A&limit=$limit&after=$a&before=$b" -H "accept: application/json")"
        
        cpu+="$(echo $get_transaction | jq '.actions[].cpu_usage_us')"
        net+="$(echo $get_transaction | jq '.actions[].net_usage_words')"
        len_transaction+="$(echo $get_transaction | jq '.actions[].data')"

        echo "_______________________________________________"
        start="$(date -d"$start + 30 minutes" +"%H:%M:%S %Y-%m-%d")"
done

cpu_sum=0
for i in ${cpu[@]}; do
  let cpu_sum+=$i
done
echo "Total CPU: $cpu_sum"

net_sum=0
for i in ${net[@]}; do
  let net_sum+=$i
done
echo "Total NET: $net_sum"

