#sudo apt-get install jq

read -p 'Enter Name of Contract: ' contract_name
read -p 'Enter Start DTG  (ISO8601): ' start_dtg
read -p 'Enter End DTG  (ISO8601):'  end_dtg

let cpu
let net
let limit=10

cpu="$(curl -X GET "https://junglehistory.cryptolions.io/v2/history/get_actions?filter=$contract_name%3A%2A&limit=$limit&after=$start_dtg&before=$end_dtg" -H "accept: applicat$

net="$(curl -X GET "https://junglehistory.cryptolions.io/v2/history/get_actions?filter=$contract_name%3A%2A&limit=$limit&after=$start_dtg&before=$end_dtg" -H "accept: applicat$

curl -X GET "https://junglehistory.cryptolions.io/v2/history/get_actions?filter=$contract_name%3A%2A&limit=$limit&after=$start_dtg&before=$end_dtg" -H "accept: application/jso$
echo "_______________________________________________"
printf "Total size of all transaction bodies(count of bytes present in a transaction): "; wc -c transaction.txt

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

