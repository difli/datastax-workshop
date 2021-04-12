# Get from Astra Dashboard: Connect -> Document API -> ASTRA_DB_ID
FIRST_DB_ID="3ef3bc11-93a9-481f-b3e2-10c080fed804"
# Get from Astra Dashboard: Connect -> Document API -> ASTRA_DB_REGION
FIRST_DB_REGION="eu-central-1"
# Get from Astra Dashboard: Connect -> Document API -> ASTRA_DB_KEYSPACE
FIRST_DB_KEYSPACE="serverless"
# Get from Astra Dashboard: Settings -> Application Tokens -> Client ID
FIRST_DB_USER="KdIPZbhfXTiHvcRwkBSDAHxa"

export ASTRA_DB_BUNDLE="astra-creds.zip"
gp env ASTRA_DB_BUNDLE="astra-creds.zip" &>/dev/null

export ASTRA_DB_USERNAME=$(echo ${FIRST_DB_USER} | sed "s/\"//g")
gp env ASTRA_DB_USERNAME=$(echo ${FIRST_DB_USER} | sed "s/\"//g") &>/dev/null

export ASTRA_DB_KEYSPACE=$(echo ${FIRST_DB_KEYSPACE} | sed "s/\"//g")
gp env ASTRA_DB_KEYSPACE=$(echo ${FIRST_DB_KEYSPACE} | sed "s/\"//g") &>/dev/null

export ASTRA_DB_ID=$(echo ${FIRST_DB_ID} | sed "s/\"//g")
gp env ASTRA_DB_ID=$(echo ${FIRST_DB_ID} | sed "s/\"//g") &>/dev/null

export ASTRA_DB_REGION=$(echo ${FIRST_DB_REGION} | sed "s/\"//g")
gp env ASTRA_DB_REGION=$(echo ${FIRST_DB_REGION} | sed "s/\"//g") &>/dev/null

# Get from Astra Dashboard: Settings -> Application Tokens -> Client Secret
echo "What is your Astra DB Client Secret? 🔒"
read -s ASTRA_DB_PASSWORD
export ASTRA_DB_PASSWORD=${ASTRA_DB_PASSWORD}
gp env ASTRA_DB_PASSWORD=${ASTRA_DB_PASSWORD} &>/dev/null

echo "You're all set 👌"
echo "Now run 'mvn spring-boot:run'"
