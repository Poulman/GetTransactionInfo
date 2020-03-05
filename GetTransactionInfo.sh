#!/bin/bash
#sudo apt-get install jq

#read -p 'Enter Name of Contract: ' account
#read -p 'Enter Start DTG  (ISO8601): ' start_dtg
#read -p 'Enter End DTG  (ISO8601):'  end_dtg

account=newdexpublic
start_dtg=2019-01-01T00:00:00.782Z
end_dtg=2020-01-01T00:00:00.782Z

EOSsweden="https://api.eossweden.org/v2/history/get_actions?"
EOSmainnet="https://mainnet.eosn.io/v2/history/get_actions?"
Wax="https://api.waxsweden.org/v2/history/get_actions?"
Telos="https://mainnet.telosusa.io/v2/history/get_actions?"
MEETONE="https://api.meetsweden.org/v2/history/get_actions?"
Jungle="https://junglehistory.cryptolions.io/v2/history/get_actions?"
Jungle_eosusa="https://jungle.eosusa.news/v2/history/get_actions?"
jungle_eossweden="https://jungle.eossweden.org/v2/history/get_actions?"
Aikon="https://ore.eosusa.news/v2/history/get_actions?"

history_link=$EOSsweden

end="$(date -d "$end_dtg" "+%s")"
start="$(date -d "$start_dtg" "+%s")"

steap=1800
#30 min=1800   1 hour=3800    1 day= 86400

limit=1000

while [[ "$start" < "$end" ]]; do
        start1="$(($start + $steap))"
        a="$(date -d @"$start" +"%Y-%m-%dT%H:%M:%S")"
        b="$(date -d @"$start1" +"%Y-%m-%dT%H:%M:%S")"
#get_transaction="$(curl -X GET "https://api.eossweden.org/v2/history/get_actions?filter=prometheusup%3A%2A&after=$a.782Z&before=$b.782Z" -H "accept: application/json")"
get_transaction="$(curl -s -X GET "$history_link&filter=$account%3A%2A&after=$a&before=$b" -H "accept: application/json")"
echo $get_transaction
for row in $(echo "${get_transaction}" | jq -r '.actions[] | @base64'); do
    _jq() {
    echo ${row} | base64 --decode | jq -r ${1}
    }
    let net="$(echo $(_jq '.net_usage_words'))"
    let cpu="$(echo $(_jq '.cpu_usage_us'))"
    let "cpu_sum=cpu_sum+cpu"
    let "net_sum=net_sum+net"
    echo "cpu_sum $cpu_sum"
    echo "net_sum $net_sum"
    echo "CPU: $cpu"
    echo "NET: $net"
done

echo "  $a ||  $b"
start="$(($start + $steap))"
echo "___________________________"
done

let "net_sum=net_sum*8"
echo $account
echo "Total CPU: $cpu_sum"
echo "Total NET: $net_sum"
