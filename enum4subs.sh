#!/bin/bash

save_dir=$(date +"enum4subs_%m%d%y%H%M")
list_name=""
domain_name=""
notify_dir="notify"
notify_config=""
#should_sort=false
should_enumerate=false
do_notify=false
#domain_dir=""
#sorted_dir="sorted-${save_dir}"
sorted=$(date +"sorted_%m%d%y%H%M")
##### Color Outputs #####
normal="\033[0m"
b_color_red="\033[1;31m"
b_color_green="\033[1;32m"
b_color_yellow="\033[1;33m"
b_color_blue="\033[1;34m"
b_color_purple="\033[1;35m"
b_color_cyan="\033[1;36m"

function create_save_directory {
  if [ "$should_enumerate" == true ]; then
    if [ ! -d "$save_dir" ]; then
      mkdir "$save_dir"
    fi
  fi
}

function print_default_message {
  echo -e """
  ${b_color_green}-h ) ${normal} Show help.
  ${b_color_green}-d ) ${normal} Finding single domain of a target.
  ${b_color_green}-l ) ${normal} Finding domain on a list.
  ${b_color_green}-n ) ${normal} Send Notification using notify tool please provide (provider-config.yaml) 
  
  """
}
function probing_subs {
  #echo -e "${b_color_purple}-- Resolving All Sorted Subdomains..${normal}\n"

  #dnsx -silent -l "${sorted}/httpx/enum4subs_allsubs.txt" -o "${sorted}/httpx/enum4subs_allsubs_dnsx_resolve.txt"
  local notify="$notify_config"

  echo -e "${b_color_purple}-- Probing All Sorted Subdomains..${normal}\n"
  ### Test for Now #########
  cat "${sorted}/enum4subs_allsubs.txt" | httprobe -c 50 -t 5000 >> "${sorted}/httprobe/enum4subs_allsubs_httprobe.txt"
  cat "${sorted}/httprobe/enum4subs_allsubs_httprobe.txt" | cut -d '/' -f 3 | sort -u >> "${sorted}/httprobe/enum4subs_allsubs_httprobe-sorted.txt"
  #nmap -sV -vv -iL "${sorted}/httprobe/enum4subs_allsubs_httprobe-sorted.txt" -oA "${sorted}/httprobe/nmap"
  ##########################
  httpx -l "${sorted}/httprobe/enum4subs_allsubs_httprobe-sorted.txt" -silent -td -cname -vhost -sc -title -cl -ct -t 60 -ip -o "${sorted}/httpx/enum4subs_allsubs_httpx.txt"
  echo -e "\n${b_color_purple}-- Sorting Subdomains by Status Codes ${normal}\n"
  
  result_200=$(grep "32m200" ${sorted}/httpx/"enum4subs_allsubs_httpx.txt")
  if [ -n "$result_200" ]; then
    echo -e "\n${b_color_purple}-- Status Code ${b_color_green}[200] ${normal}\n"
    first_field_1=$(grep "32m200" ${sorted}/httpx/"enum4subs_allsubs_httpx.txt"  | tee -a "${sorted}/httpx/enum4subs_allsubs_status_200.txt")
    echo "${first_field_1}"
    #Test for now do notify
    echo "\n\n==== [200 OK] ====\n\n">"${sorted}/notify-200.txt";cat "${sorted}/httpx/enum4subs_allsubs_status_200.txt">>"${sorted}/notify-200.txt"

    if [ "$do_notify" = true]; then
    notify -i "${sorted}/notify-200.txt" -pc "${notify}" -bulk -silent >>/dev/null
    fi

  else
    echo ""
  fi   
  result_301=$(grep "33m301" ${sorted}/httpx/"enum4subs_allsubs_httpx.txt")
  if [ -n "$result_301" ]; then
    echo -e "\n${b_color_purple}-- Status Code ${b_color_cyan}[301] ${normal}\n"
    first_field_2=$(grep "33m301" ${sorted}/httpx/"enum4subs_allsubs_httpx.txt"  | tee -a "${sorted}/httpx/enum4subs_allsubs_status_301.txt")
    echo "${first_field_2}"
  else
    echo ""
  fi   

  result_302=$(grep "33m302" ${sorted}/httpx/"enum4subs_allsubs_httpx.txt")
  if [ -n "$result_302" ]; then
    echo -e "\n${b_color_purple}-- Status Code ${b_color_cyan}[302] ${normal}\n"
    first_field_3=$(grep "33m302" ${sorted}/httpx/"enum4subs_allsubs_httpx.txt"  | tee -a "${sorted}/httpx/enum4subs_allsubs_status_302.txt")
    echo "${first_field_3}"
  else
    echo ""
  fi  

  result_303=$(grep "33m303" ${sorted}/httpx/"enum4subs_allsubs_httpx.txt")
  if [ -n "$result_303" ]; then
    echo -e "\n${b_color_purple}-- Status Code ${b_color_cyan}[303] ${normal}\n"
    first_field_4=$(grep "33m303" ${sorted}/httpx/"enum4subs_allsubs_httpx.txt"  | tee -a "${sorted}/httpx/enum4subs_allsubs_status_303.txt")
    echo "${first_field_4}"
  else
    echo ""
  fi

  result_307=$(grep "33m307" ${sorted}/httpx/"enum4subs_allsubs_httpx.txt")
  if [ -n "$result_307" ]; then
    echo -e "\n${b_color_purple}-- Status Code ${b_color_cyan}[307] ${normal}\n"
    first_field_4=$(grep "33m307" ${sorted}/httpx/"enum4subs_allsubs_httpx.txt"  | tee -a "${sorted}/httpx/enum4subs_allsubs_status_307.txt")
    echo "${first_field_4}"
  else
    echo ""    
  fi  
  result_401=$(grep "31m401"  ${sorted}/httpx/"enum4subs_allsubs_httpx.txt")
  if [ -n "$result_401" ]; then
    echo -e "\n${b_color_purple}-- Status Code ${b_color_yellow}[401] ${normal}\n"
    first_field_5=$(grep "31m401"  ${sorted}/"enum4subs_allsubs_httpx.txt"  | tee -a "${sorted}/httpx/enum4subs_allsubs_status_401.txt")
    echo "${first_field_5}"
  else
    echo ""
  fi    

  result_403=$(grep "31m403"  ${sorted}/httpx/"enum4subs_allsubs_httpx.txt")
  if [ -n "$result_403" ]; then
    echo -e "\n${b_color_purple}-- Status Code ${b_color_purple}[403] ${normal}\n"
    first_field_6=$(grep "31m403"  ${sorted}/httpx/"enum4subs_allsubs_httpx.txt"  | tee -a "${sorted}/httpx/enum4subs_allsubs_status_403.txt")
    echo "${first_field_6}"
  else
    echo ""
  fi  

  result_404=$(grep "31m404"  ${sorted}/"enum4subs_allsubs_httpx.txt")
  if [ -n "$result_404" ]; then
  echo -e "\n${b_color_purple}-- Status Code ${b_color_blue}[404] ${normal}\n"
    first_field_7=$(grep "31m404"  ${sorted}/"enum4subs_allsubs_httpx.txt"  | tee -a "${sorted}/httpx/enum4subs_allsubs_status_404.txt")
  echo "${first_field_7}"
  else
    echo ""
  fi  
  result_500=$(grep "33m500" ${sorted}/httpx/"enum4subs_allsubs_httpx.txt")
  if [ -n "$result_500" ]; then
    echo -e "\n${b_color_purple}-- Status Code ${b_color_red}[500] ${normal}\n"
    first_field_8=$(grep "33m500" ${sorted}/httpx/"enum4subs_allsubs_httpx.txt"  | tee -a "${sorted}/httpx/enum4subs_allsubs_status_500.txt")
    echo "${first_field_8}"
  else
    echo ""
  fi   
  result_501=$(grep "33m501" ${sorted}/httpx/"enum4subs_allsubs_httpx.txt")
  if [ -n "$result_501" ]; then
    echo -e "\n${b_color_purple}-- Status Code ${b_color_red}[501] ${normal}\n"
    first_field_9=$(grep "33m501" ${sorted}/httpx/"enum4subs_allsubs_httpx.txt"  | tee -a "${sorted}/httpx/enum4subs_allsubs_status_501.txt")
    echo "${first_field_9}"
  else
    echo ""
  fi   
  result_502=$(grep "33m502" ${sorted}/httpx/"enum4subs_allsubs_httpx.txt")
  if [ -n "$result_502" ]; then
    echo -e "\n${b_color_purple}-- Status Code ${b_color_red}[502] ${normal}\n"
    first_field_10=$(grep "33m502" ${sorted}/httpx/"enum4subs_allsubs_httpx.txt"  | tee -a  "${sorted}/httpx/enum4subs_allsubs_status_502.txt")
    echo "${first_field_10}"
  else
    echo ""
  fi  

  result_503=$(grep "33m503" ${sorted}/httpx/"enum4subs_allsubs_httpx.txt")
  if [ -n "$result_503" ]; then
    echo -e "\n${b_color_purple}-- Status Code ${b_color_red}[503] ${normal}\n"
    first_field_10=$(grep "33m503" ${sorted}/httpx/"enum4subs_allsubs_httpx.txt"  | tee -a  "${sorted}/httpx/enum4subs_allsubs_status_503.txt")
    echo "${first_field_10}"
  else
    echo ""
  fi  

  no_status=$(grep "\[\]" ${sorted}/httpx/"enum4subs_allsubs_httpx.txt")
  if [ -n "$no_status" ]; then
    echo -e "\n${b_color_purple}-- Status Code ${normal}[ ] ${normal}\n"
    echo "$no_status"  | tee -a "${sorted}/httpx/enum4subs_allsubs_status_none.txt"
  else
    echo ""
  fi 
  ip_address=$(grep "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}" ${sorted}/httpx/"enum4subs_allsubs_httpx.txt")
  if [ -n "$ip_address" ]; then
    echo -e "\n${b_color_purple}-- IP Address ${normal}\n"
    first_ip=$(grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}" ${sorted}/httpx/"enum4subs_allsubs_httpx.txt" | sort -u  | tee -a "${sorted}/httpx/enum4subs_allsubs_ip_address.txt")
    #echo "${first_ip}"
  else
    echo ""
  fi 

  probe_ip_address=$(grep "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}" ${sorted}/httpx/"enum4subs_allsubs_ip_address.txt")
  if [ -n "$probe_ip_address" ]; then
    echo -e "\n${b_color_purple}-- IP Address Info ${normal}\n"
    httpx -silent -title -sc -cl -td -cname -probe -l ${sorted}/httpx/"enum4subs_allsubs_ip_address.txt" -o "${sorted}/httpx/enum4subs_allsubs_ip_address_probe.txt"
    echo -e "\n${b_color_green}Done!! ${normal}\n"
  else
    echo ""
  fi  
}

function combine_sort {
  echo -e "${b_color_purple}-- Sorting Subdomains.!!${normal}"
    if [ ! -d "$sorted" ]; then
      mkdir "$sorted"
      mkdir "$sorted/httpx"
      mkdir "$sorted/httprobe"
      mkdir "$sorted/httprobe/nmap"
      cat enum4subs_*/*/*".txt" | sort -u >> "${sorted}/enum4subs_allsubs.txt"
      echo -e "\n${b_color_green}Sorting Complete.!!${normal}\n"
      echo -e "\n${b_color_purple}Sorted output are save in ${sorted} folder.!!${normal}\n"
      probing_subs
    fi
}
function list_enum {
  local file_name="$list_name"

  if [ -f "$file_name" ]; then
    while IFS= read -r domain; do
      if [ ! -d "$save_dir/$domain/" ]; then
        mkdir "$save_dir/$domain"
      fi
      echo -e "\n${b_color_yellow}-- Finding Subdomains for [ ${b_color_purple}${domain} ${b_color_yellow}]${normal}\n"
      curl -s "https://crt.sh/?q=%.$domain&output=json" | jq -r ".[].name_value" | sed "s/\*\.//; s/https:\/\/\///; s/http:\/\/\///; s/\_//g" | grep -v "\@|\/" | sort -u | tee "$save_dir/$domain/${domain}-crtsh.txt"
      curl -s "https://crt.sh/?q=%.$domain&output=json" | grep  -E "common_name|name_value" | sed "s/\,/\n/g" | grep "common_name" | grep -Ev " |\@|\/" | sed "s/\"common_name\":\"//; s/\"//; s/\*\.//; s/https:\/\/\///; s/http:\/\/\///; s/\_//g" | sort -u | grep "$domain" | tee "$save_dir/$domain/${domain}-crtsh-02.txt"
      #assetfinder --subs-only "$domain" | grep -Ev " |\@|\/" | sed "s/\*\.//; s/https:\/\/\///; s/http:\/\/\///; s/\_//g" | sort -u | tee "$save_dir/$domain/${domain}-assetfinder.txt"
      subfinder -all -silent -d "$domain" -o "$save_dir/$domain/${domain}-subfinder.txt"
      subfinder -recursive -silent -d "$domain" -o "$save_dir/$domain/${domain}-subfinder-recursive.txt"
      "/opt/tools/amass-3.23.3/amass" enum -passive  -d "$domain" -o "$save_dir/$domain/${domain}-amass.txt" -config "/opt/tools/amass-config/config.ini" -norecursive -nocolor
      #"/opt/tools/amass-3.23.3/amass" enum -brute  -d "$domain" -o "$save_dir/$domain/${domain}-amass-brute.txt" -config "/opt/tools/amass-config/config.ini" -nocolor -norecursive     
      python3 /opt/tools/python-permute/sub-permute.py -d "$domain" -o "$save_dir/$domain/${domain}-permute.txt" -l 2 -w "/opt/tools/python-permute/subdomains-tiny.txt" -t 5
      #domain_dir="$domain"
    done < "$file_name"
    combine_sort
  else
    echo -e "\n${b_color_red}File not Exist!!${normal}\n"
  fi
}


function domain_enum {
  local domain="$domain_name"

  if [ ! -d "$save_dir/$domain/" ]; then
    mkdir "$save_dir/$domain"
  fi
  echo -e "\n${b_color_yellow}-- Finding Subdomains for [ ${b_color_purple}${domain} ${b_color_yellow}]\n${normal}"
  curl -s "https://crt.sh/?q=%.$domain&output=json" | jq -r ".[].name_value" | sed "s/\*\.//; s/https:\/\/\///; s/http:\/\/\///; s/\_//g" | grep -v "\@|\/" | sort -u | tee "$save_dir/$domain/${domain}-crtsh.txt"
  #Incase jq fail it will send onother request and parse the subdomains manually
  curl -s "https://crt.sh/?q=%.$domain&output=json" | grep -E "common_name|name_value" | sed "s/\,/\n/g" | grep "common_name" | grep -Ev " |\@" | sed "s/\"common_name\":\"//; s/\"//; s/\*\.//; s/https:\/\/\///; s/http:\/\/\///; s/\_//g" | grep "$domain" | sort -u | tee "$save_dir/$domain/${domain}-crtsh-02.txt"
  #assetfinder --subs-only "$domain" | grep -Ev " |\@|\/" | sed "s/\*\.//; s/https:\/\/\///; s/http:\/\/\///; s/\_//g" | sort -u | tee "$save_dir/$domain/${domain}-assetfinder.txt"
  subfinder -all -silent -d "$domain" -o "$save_dir/$domain/${domain}-subfinder.txt"
  subfinder -recursive -silent -d "$domain" -o "$save_dir/$domain/${domain}-subfinder-recursive.txt"
  "/opt/tools/amass-3.23.3/amass" enum -passive -d "$domain" -o "$save_dir/$domain/${domain}-amass.txt" -config "/opt/tools/amass-config/config.ini" -norecursive -nocolor
  #"/opt/tools/amass-3.23.3/amass" enum -brute -d "$domain" -o "$save_dir/$domain/${domain}-amass-brute.txt" -config "/opt/tools/amass-config/config.ini" -nocolor -norecursive
  python3 /opt/tools/python-permute/sub-permute.py -d "$domain" -o "$save_dir/$domain/${domain}-permute.txt" -l 2 -w "/opt/tools/python-permute/subdomains-tiny.txt" -t 5
  combine_sort
}

while getopts "hd:l:n:" opt
do
  case $opt in
    d)
      domain_name="${OPTARG}"
      should_enumerate=true
      create_save_directory
      domain_enum
      ;;
    l)
      list_name="${OPTARG}"
      should_enumerate=true
      create_save_directory
      list_enum
      ;;
    n)
      notify_config="${OPTARG}"
      do_notify=true
      ;;  
    h)
      print_default_message
      exit 1
      ;;
    \?)
      print_default_message
      ;;
    :)
      echo -e "${b_color_red}Option ${OPTARG} requires an argument.${normal}" >&2
      ;;
    *)
      ;;
  esac
done
