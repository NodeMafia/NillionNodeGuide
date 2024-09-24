#!/bin/bash

# Node Mafia ASCII Art
echo "
     __             _                        __  _        
  /\ \ \  ___    __| |  ___   /\/\    __ _  / _|(_)  __ _ 
 /  \/ / / _ \  / _\` | / _ \ /    \  / _\` || |_ | | / _\` |
/ /\  / | (_) || (_| ||  __// /\/\ \| (_| ||  _|| || (_| |
\_\ \/   \___/  \__,_| \___|\/    \/ \__,_||_|  |_| \__,_|
                                                          
EN Telegram: soon..
RU Telegram: https://t.me/SixThoughtsLines
GitHub: https://github.com/NodeMafia
"

# Check if Docker is accessible
if ! docker info > /dev/null 2>&1; then
    echo -e "\e[31mPermission denied: You don't have access to Docker.\e[0m"
    echo -e "\e[31mTrying to add user to the docker group...\e[0m"
    
    # Try to add user to the docker group
    sudo usermod -aG docker $USER

    echo -e "\e[32mUser added to the docker group. Please log out and log back in or restart the terminal.\e[0m"
    echo -e "\e[32mOr you can run the script with 'sudo'.\e[0m"
    
    exit 1
else
    echo -e "\e[32mDocker is accessible. Proceeding...\e[0m"
fi

# Pull the Nillion verifier Docker image
echo "Pulling Nillion verifier docker image..."
docker pull nillion/verifier:v1.0.0

# Create directory for the Nillion Verifier
mkdir -p nillion/verifier

# Initialize the Verifier
docker run -v $(pwd)/nillion/verifier:/var/tmp nillion/verifier:v1.0.0 initialise

# Extract data from credentials.json
JSON_FILE="./nillion/verifier/credentials.json"
if [ -f "$JSON_FILE" ]; then
    echo "Extracting data from credentials.json..."
    ADDRESS=$(jq -r '.address' $JSON_FILE)
    PUBKEY=$(jq -r '.pub_key' $JSON_FILE)

    # Combined output instructions
    echo -e "\n\e[31m!INSTRUCTIONS FOR USE!\e[0m"
    echo -e "1. Go to the site: https://verifier.nillion.com/verifier and log in using your EVM wallet."
    echo -e "2. Press 'Set Up For Linux' and go to step 5: 'Initialising the verifier'"
    echo -e "   Enter the following details:"
    
    # Added message to copy information
    echo -e "\e[31mTo copy the information, highlight it with your cursor (do not press CTRL+C). The information will be copied after highlighting.\e[0m"
    
    echo -e "   \e[36mVerifier Account ID:\e[0m = $ADDRESS"
    echo -e "   \e[36mVerifier Public Key:\e[0m = $PUBKEY"
    echo -e "3. Go to the \e[33mNillion Faucet\e[0m and get tokens to the address: \e[36m$ADDRESS\e[0m"
    echo -e "   Visit: https://faucet.testnet.nillion.com"
    echo ""
else
    echo -e "\e[31mError: credentials.json not found!\e[0m"
    exit 1
fi

# Short Docker Usage Guide
echo -e "\e[31mShort Docker Usage Guide\e[0m"
echo -e "\e[36mList running containers:\e[0m docker ps"
echo -e "\e[36mView Docker logs:\e[0m docker logs -f <CONTAINER ID>"
echo -e "\e[36mView last 10 lines of logs:\e[0m docker logs -n 10 -f <CONTAINER ID>"
echo -e "\e[36mStop viewing logs:\e[0m CTRL+C"

# Wait for user input
read -p "Press Enter to continue after completing the steps..."

# Synchronization timer with progress bar
echo -e "\e[33mWaiting 5 minutes for synchronization...\e[0m"
for i in {1..100}; do
    sleep 3
    echo -ne "\rSynchronization progress... $i%"
done

# After the timer ends
echo -e "\n\e[32mSynchronization complete!\e[0m"

# Run the Verifier node
docker run -v $(pwd)/nillion/verifier:/var/tmp nillion/verifier:v1.0.0 verify --rpc-endpoint "https://testnet-nillion-rpc.lavenderfive.com"
