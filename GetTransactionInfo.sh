#!/bin/bash
#sudo apt-get install jq

read -p 'Enter Name of Contract: ' account
read -p 'Enter Start DTG  (ISO8601): ' start_dtg
read -p 'Enter End DTG  (ISO8601):'  end_dtg

#account=ilovekolobok
#start_dtg=2020-01-28T20:28:56
#end_dtg=2020-02-01T23:28:56

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

steap=86400
#30 min=1800   1 hour=3800    1 day= 86400

limit=100

while [[ "$start" < "$end" ]]; do

        start1="$(($start + $steap))"
        a="$(date -d @"$start" +"%Y-%m-%dT%H:%M:%S")"
        b="$(date -d @"$start1" +"%Y-%m-%dT%H:%M:%S")"

get_transaction="$(curl -X GET "$history_link&account=$account&after=$a&before=$b" -H "accept: application/json")"
start="$(($start + $steap))"
done

for row in $(echo "${get_transaction}" | jq -r '.actions[] | @base64'); do
    _jq() {
    echo ${row} | base64 --decode | jq -r ${1}
    }
    let net+="$(echo $(_jq '.net_usage_words'))"
    let cpu+="$(echo $(_jq '.cpu_usage_us'))"
done

let "net_sum=net_sum*8"
echo "$history_link :"
echo "Total CPU: $cpu"
echo "Total NET: $net"


