#!/bin/bash

main_api="https://smailpro.com"
rapid_api="https://public-sonjj.p.rapidapi.com"
rapid_api_key="f871a22852mshc3ccc49e34af1e8p126682jsn734696f1f081"
user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36"

function get_cookies() {
	response=$(curl --request GET \
		--url "$api" \
		--user-agent "$user_agent" \
		-i -s)
	cookie=$(echo "$response" | grep -iE '^set-cookie:' | awk '{print $2}')
}

function get_email_key() {
	response=$(curl --request POST \
		--url "$main_api/app/key" \
		--user-agent "$user_agent" \
		--header "content-type: application/json" \
		--header "cookie: $cookie" \
		--data '{
			"domain": "gmail.com",
			"username": "random",
			"server": "server-1",
			"type": "alias"
		}')
	if [ -n $(jq -r ".items" <<< "$response") ]; then
		email_key=$(jq -r ".items" <<< "$response")
	fi
	echo $response
}

function generate_email() {
	curl --request GET \
		--url "$rapid_api/email/gm/get?key=$email_key&rapidapi-key=$rapid_api_key&domain=gmail.com&username=random&server=server-1&type=alias" \
		--header "content-type: application/json" \
		--user-agent "$user_agent"
}

function get_inbox() {
	# 1 - email: (string): <email>
	curl --request GET \
		--url "$rapid_api/email/gm/check?key=$email_key&rapidapi-key=$rapid_api_key&email=$1" \
		--header "content-type: application/json" \
		--user-agent "$user_agent"
}
