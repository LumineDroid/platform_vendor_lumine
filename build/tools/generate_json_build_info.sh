#!/bin/bash
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
NC="\033[0m"

findPayloadOffset() {
    build=$1
    info=$(zipdetails "$build")
    foundBin=0
    while IFS= read -r line; do
        if [[ $foundBin == 1 ]]; then
            echo "$line" | grep -q "PAYLOAD"
            res=$?
            if [[ $res == 0 ]]; then
                hexNum=$(echo "$line" | cut -d ' ' -f1)
                echo $(( 16#$hexNum ))
                break
            fi
            continue
        fi
        echo "$line" | grep -q "payload.bin"
        res=$?
        [[ $res == 0 ]] && foundBin=1
    done <<< "$info"
}

if ! [ "$1" ]; then
    echo -e "${RED}No file provided${NC}"
    if ! return 0 &> /dev/null; then
        exit 0
    fi
fi

file_path=$1
file_dir=$(dirname "$file_path")
file_name=$(basename "$file_path")
device=$(echo $TARGET_PRODUCT | sed 's/lumine_//g')
version="bellflower"
url="https://sourceforge.net/projects/luminedroid/files/${device}/${version}/${file_name}/download"
sha256_hash="$(cat "$file_path.sha256sum" | cut -d' ' -f1)"

if ! [ -f "$file_path" ]; then
    echo -e "${RED}File does not exist${NC}"
    if ! return 0 &> /dev/null; then
        exit 0
    fi
fi

echo -e "${GREEN}Generating .json${NC}"

isPayload=0
[ -f payload_properties.txt ] && rm payload_properties.txt
if unzip "$file_path" payload_properties.txt; then
    isPayload=1
    offset=$(findPayloadOffset "$file_path")
    keyPairs=$(cat payload_properties.txt | sed "s/=/\": \"/" | sed 's/^/            \"/' | sed 's/$/\"\,/')
    keyPairs=${keyPairs%?}
fi

datetime=$(date +%s)

# Start building the JSON file
{
    echo "{"
    echo "  \"response\": ["
    echo "    {"
    echo "      \"datetime\": ${datetime},"
    echo "      \"filename\": \"${file_name}\","
    echo "      \"url\": \"${url}\","
    echo -n "      \"sha256\": \"${sha256_hash}\""
} > "${file_path}.json"

# Conditionally add the payload section
if [[ $isPayload == 1 ]]; then
    {
        echo ","
        echo "      \"payload\": ["
        echo "        {"
        echo "          \"offset\": ${offset},"
        echo "${keyPairs}"
        echo "        }"
        echo "      ]"
    } >> "${file_path}.json"
fi

# Close the JSON structure
{
    echo "    }"
    echo "  ]"
    echo "}"
} >> "${file_path}.json"

mv "${file_path}.json" "${file_dir}/${device}.json"
echo -e "${GREEN}Done generating ${YELLOW}${device}.json${NC}"
