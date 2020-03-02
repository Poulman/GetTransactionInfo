#!/bin/bash
#sudo apt-get install jq

read -p 'Enter Name of Contract: ' contract_name
read -p 'Enter Start DTG  (ISO8601): ' start_dtg
read -p 'Enter End DTG  (ISO8601):'  end_dtg

#contract_name=ilovekolobok
#start_dtg=2020-01-28T20:28:56
#end_dtg=2020-02-01T23:28:56

end="$(date -d "$end_dtg" +"%H:%M:%S %Y-%m-%d")"
start="$(date -d "$start_dtg" +"%H:%M:%S %Y-%m-%d")"

limit=10000000000

while [ "$start" != "$end" ]; do
        start1="$(date -d"$start + 30 minutes" +"%H:%M:%S %Y-%m-%d")"
        a="$(date -d "$start" +"%Y-%m-%dT%H:%M:%S")"
        b="$(date -d "$start1" +"%Y-%m-%dT%H:%M:%S")"

get_transaction="$(curl -X GET "https://ore.eosusa.news/v2/history/get_actions?limit=$limit&after=$a&before=$b" -H "accept: application/json")"

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
start="$(date -d"$start + 30 minutes" +"%H:%M:%S %Y-%m-%d")"
done

echo "Total CPU: $cpu_sum"

echo "Total NET: $net_sum"

echo "Total LEN: $transaction_sum"
