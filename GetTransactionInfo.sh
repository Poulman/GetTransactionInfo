#!/bin/bash
#sudo apt-get install jq

read -p 'Enter Name of Contract: ' contract_name
read -p 'Enter Start DTG  (ISO8601): ' start_dtg
read -p 'Enter End DTG  (ISO8601):'  end_dtg

#contract_name=ilovekolobok
#start_dtg=2020-01-28T20:28:56
#end_dtg=2020-02-01T23:28:56

end="$(date -d "$end_dtg" "+%s")"
start="$(date -d "$start_dtg" "+%s")"

steap=3800
#30 min=1800   1 hour=3800    1 day= 86400

limit=1000000000

echo $start
echo $end

while [[ "$start" < "$end" ]]; do

        start1="$(($start + $steap))"
        a="$(date -d @"$start" +"%Y-%m-%dT%H:%M:%S")"
        b="$(date -d @"$start1" +"%Y-%m-%dT%H:%M:%S")"

#get_transaction="$(curl -X GET "https://jungle.eossweden.org/v2/history/get_actions?limit=$limit&filter=$contract_name%3A%2A&after=$a&before=$b" -H "accept: application/json")"
get_transaction="$(curl -X GET "https://api.eossweden.org/v2/history/get_actions?filter=ilovekolobok%3A%2A&after=$a&before=$b" -H "accept: application/json")"

cpu="$(echo $get_transaction | jq '.actions[].cpu_usage_us')"
        for i in ${cpu[@]}; do
                let cpu_sum+=$i
        done

net="$(echo $get_transaction | jq '.actions[].net_usage_words')"
        for i in ${net[@]}; do
                let net_sum+=$i
        done

len_transaction="$(echo $get_transaction | jq '.actions[].data')"
        for i in ${len_transaction[@]}; do
                let transaction_sum+=i
        done

echo "_______________________________________________"
start="$(($start + $steap))"
done

echo "Total CPU: $cpu_sum"

echo "Total NET: $net_sum"

echo "Total LEN: $transaction_sum"
