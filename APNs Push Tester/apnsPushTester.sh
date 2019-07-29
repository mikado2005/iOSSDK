#!/bin/bash

# This script will send one Apple Push Notification service message to a single
# Apple device using curl and openSSL.

# Get curl with HTTP/2 and openssl with ECDSA for Mac: 'brew install curl-openssl'
curl=/usr/local/opt/curl-openssl/bin/curl
openssl=/usr/local/opt/openssl/bin/openssl

# --------------------------------------------------------------------------
# Some required inputs:

# The APNs device token of the user's iPhone
deviceToken=611bbaf643aa2607ba37b2bc94afbe92d08404b981f431bb6d160c6f0263e2ab

# The *.p8 file containing your APNs Key
authKey="./MyOrgsAPNsAuthenticationKey.p8"

# The ID # of the APNs key
authKeyId=27BTQ6933M

# Your app's Apple team ID
teamId=9DAT7A9Z28

# Your app's Bundle Identifier
bundleId=com.planetbeagle.TheoremReachiOSExampleApp
# --------------------------------------------------------------------------

appleEndpoint=https://api.development.push.apple.com

# This is the data payload of the notification.  You may add badges, categories, texts, etc
# The 'acuid' parameter is required.  That's the survey ID from TheoremReach.
read -r -d '' payload <<-'EOF'
{
 "aps": {
    "alert": {
        "category": "TheoremReach Client App",
        "title": "A survey is available for you!",
        "subtitle": "Tap here to open it"
    }
 },
 "acuid":"0bb25f4d-6579-4218-bb5f-202f6db32972"
}
EOF

# This shows how to set other APNs notification parameters:
# read -r -d '' payload <<-'EOF'
# {
#    "aps": {
#       "badge": 2,
#       "category": "mycategory",
#       "alert": {
#          "title": "my title",
#          "subtitle": "my subtitle",
#          "body": "my body text message"
#       }
#    },
#    "custom": {
#       "mykey": "myvalue"
#    }
# }
#EOF

# --------------------------------------------------------------------------
# This code builds an authorization JWT document

base64() {
   $openssl base64 -e -A | tr -- '+/' '-_' | tr -d =
}

sign() {
   printf "$1"| $openssl dgst -binary -sha256 -sign "$authKey" | base64
}

time=$(date +%s)
header=$(printf '{ "alg": "ES256", "kid": "%s" }' "$authKeyId" | base64)
claims=$(printf '{ "iss": "%s", "iat": %d }' "$teamId" "$time" | base64)
jwt="$header.$claims.$(sign $header.$claims)"

# Send the request to Apple's API endpoint.  Add/remove --verbose for more/less debug output
$curl --verbose \
   --output apnsPushTester.out \
   --header "content-type: application/json" \
   --header "authorization: bearer $jwt" \
   --header "apns-topic: $bundleId" \
   --data "$payload" \
   $appleEndpoint/3/device/$deviceToken
