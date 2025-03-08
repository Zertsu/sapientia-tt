#!/bin/bash

curl 'https://sapientia-emte.edupage.org/timetable/server/ttviewer.js?__func=getTTViewerData' \
  -H 'accept: */*' \
  -H 'accept-language: en-GB,en;q=0.9,en-US;q=0.8,hu;q=0.7,cs;q=0.6' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json; charset=UTF-8' \
  -H 'origin: https://sapientia-emte.edupage.org' \
  -H 'pragma: no-cache' \
  -H 'priority: u=1, i' \
  -H 'referer: https://sapientia-emte.edupage.org/' \
  -H 'sec-ch-ua: "Not(A:Brand";v="99", "Google Chrome";v="133", "Chromium";v="133"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36' \
  --data-raw '{"__args":[null,2024],"__gsh":"00000000"}' |\
jq > "$TT_SAPIENTIA_TMP"/ttviewer_getTTViewerData.json

curl 'https://sapientia-emte.edupage.org/timetable/server/regulartt.js?__func=regularttGetData' \
  -H 'accept: */*' \
  -H 'accept-language: en-GB,en;q=0.9,en-US;q=0.8,hu;q=0.7,cs;q=0.6' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json; charset=UTF-8' \
  -H 'origin: https://sapientia-emte.edupage.org' \
  -H 'pragma: no-cache' \
  -H 'priority: u=1, i' \
  -H 'referer: https://sapientia-emte.edupage.org/' \
  -H 'sec-ch-ua: "Not(A:Brand";v="99", "Google Chrome";v="133", "Chromium";v="133"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36' \
  --data-raw '{"__args":[null,"180"],"__gsh":"00000000"}' |\
jq > "$TT_SAPIENTIA_TMP"/regulartt_regularttGetData.json


current_date=$(date +%Y-%m-%d)
weekday_num=$(date +%u)
monday_date=$(date -d "$current_date -$((weekday_num - 1)) days" +%Y-%m-%d)
sunday_date=$(date -d "$current_date +$((7 - weekday_num)) days" +%Y-%m-%d)

curl 'https://sapientia-emte.edupage.org/rpr/server/maindbi.js?__func=mainDBIAccessor' \
  -H 'accept: */*' \
  -H 'accept-language: en-GB,en;q=0.9,en-US;q=0.8,hu;q=0.7,cs;q=0.6' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json; charset=UTF-8' \
  -b 'PHPSESSID=84f015684e63fc170b9d28b80101dfa3' \
  -H 'origin: https://sapientia-emte.edupage.org' \
  -H 'pragma: no-cache' \
  -H 'priority: u=1, i' \
  -H 'referer: https://sapientia-emte.edupage.org/' \
  -H 'sec-ch-ua: "Not(A:Brand";v="99", "Google Chrome";v="133", "Chromium";v="133"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36' \
  --data-raw '{"__args":[null,2024,{"vt_filter":{"datefrom":"'"$monday_date"'","dateto":"'"$sunday_date"'"}},{"op":"fetch","needed_part":{"teachers":["short","name","firstname","lastname","callname","subname","code","cb_hidden","expired"],"classes":["short","name","firstname","lastname","callname","subname","code","classroomid"],"classrooms":["short","name","firstname","lastname","callname","subname","code"],"igroups":["short","name","firstname","lastname","callname","subname","code"],"students":["short","name","firstname","lastname","callname","subname","code","classid"],"subjects":["short","name","firstname","lastname","callname","subname","code"],"events":["typ","name"],"event_types":["name","icon"],"subst_absents":["date","absent_typeid","groupname"],"periods":["short","name","firstname","lastname","callname","subname","code","period","starttime","endtime"],"dayparts":["starttime","endtime"],"dates":["tt_num","tt_day"]},"needed_combos":{}}],"__gsh":"00000000"}' |\
jq > "$TT_SAPIENTIA_TMP"/maindbi_mainDBIAccessor.json

if [[ -n "$(diff "$TT_SAPIENTIA_TMP"/ttviewer_getTTViewerData.json ./ttviewer_getTTViewerData.json)" ]]; then
    echo 'ttviewer_getTTViewerData.json changed'
    cp "$TT_SAPIENTIA_TMP"/ttviewer_getTTViewerData.json ./ttviewer_getTTViewerData.json
fi
if [[ -n "$(diff "$TT_SAPIENTIA_TMP"/regulartt_regularttGetData.json ./regulartt_regularttGetData.json)" ]]; then
    echo 'regulartt_regularttGetData.json changed'
    cp "$TT_SAPIENTIA_TMP"/regulartt_regularttGetData.json ./regulartt_regularttGetData.json
fi
if [[ -n "$(diff "$TT_SAPIENTIA_TMP"/maindbi_mainDBIAccessor.json ./maindbi_mainDBIAccessor.json)" ]]; then
    echo 'maindbi_mainDBIAccessor.json changed'
    cp "$TT_SAPIENTIA_TMP"/maindbi_mainDBIAccessor.json ./maindbi_mainDBIAccessor.json
fi

git add ttviewer_getTTViewerData.json regulartt_regularttGetData.json maindbi_mainDBIAccessor.json

if [[ $(git diff --name-only --cached) ]]; then
    git commit -m "Added detected changes at $(date '+%Y-%m-%d %H:%M')."
    git push
else
    echo "No changes found"
fi

echo 'Cleaning up temporary files'
rm "$TT_SAPIENTIA_TMP"/ttviewer_getTTViewerData.json \
  "$TT_SAPIENTIA_TMP"/regulartt_regularttGetData.json \
  "$TT_SAPIENTIA_TMP"/maindbi_mainDBIAccessor.json
