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

# Menu for user selection
echo "Please select an option:"
echo "1. Install Node"
echo "2. Update Node"
echo "3. Change RPC"
read -p "Enter the option number (1, 2, or 3): " option
echo "You entered: $option"

# Branch based on user selection
case $option in
    1)
        echo "You selected to install the Node."

        # Check if Docker is accessible
        if ! docker info > /dev/null 2>&1; then
            echo -e "\e[31mPermission denied: You don't have access to Docker.\e[0m"
            echo -e "\e[31mTrying to add user to the docker group...\e[0m"
            
            # Try to add user to the docker group
            sudo usermod -aG docker "$USER"

            echo -e "\e[32mUser added to the docker group. Please log out and log back in or restart the terminal.\e[0m"
            echo -e "\e[32mOr you can run the script with 'sudo'.\e[0m"
            
            exit 1
        else
            echo -e "\e[32mDocker is accessible. Proceeding...\e[0m"
        fi

        # Pull the Nillion verifier Docker image
        echo "Pulling Nillion verifier docker image..."
        docker pull nillion/verifier:v1.0.1

        # Create directory for the Nillion Verifier
        mkdir -p nillion/verifier

        # Initialize the Verifier
        docker run -v "$(pwd)/nillion/verifier:/var/tmp" nillion/verifier:v1.0.1 initialise

        # Extract data from credentials.json
        JSON_FILE="./nillion/verifier/credentials.json"
        if [ -f "$JSON_FILE" ]; then
            echo "Extracting data from credentials.json..."
            ADDRESS=$(jq -r '.address' "$JSON_FILE")
            PUBKEY=$(jq -r '.pub_key' "$JSON_FILE")

            # Combined output instructions
            echo -e "\n\e[31mTo copy the information, highlight it with your cursor (do not press CTRL+C).\e[0m"
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
        docker run -v "$(pwd)/nillion/verifier:/var/tmp" nillion/verifier:v1.0.1 verify --rpc-endpoint "https://testnet-nillion-rpc.lavenderfive.com"
        ;;

    2)
        echo "You selected to update the Node."

        # Find and kill the running nillion/verifier container
        CONTAINER_ID=$(docker ps -q --filter ancestor=nillion/verifier:v1.0.1)
        if [ -n "$CONTAINER_ID" ]; then
            echo "Stopping and removing the running container..."
            docker kill "$CONTAINER_ID"
            docker rm "$CONTAINER_ID"
            echo "Container stopped and removed."
        else
            echo "No running container found for the image nillion/verifier:v1.0.1. Ignoring..."
        fi

        # Pull the updated Docker image
        echo "Pulling the updated Docker image nillion/verifier:v1.0.1..."
        docker pull nillion/verifier:v1.0.1

        if [ $? -eq 0 ]; then
            echo "Successfully pulled the updated image."
        else
            echo "Failed to pull the updated image."
            exit 1
        fi

        # Run the updated Verifier node
        echo "Starting the updated Nillion Verifier node..."
        docker run -v "$(pwd)/nillion/verifier:/var/tmp" nillion/verifier:v1.0.1 verify --rpc-endpoint "https://testnet-nillion-rpc.lavenderfive.com"

        echo "Node update complete and running on v1.0.1."
        ;;

    3)
        echo "You selected to change the RPC."

        # RPC selection before stopping the container
        echo "Please select an RPC endpoint option:"
        echo "1. Testnet RPC (Lavenderfive - Standard)"
        echo "2. Testnet RPC (Polkachu)"
        echo "3. Testnet RPC (KJNodes)"
        echo "4. Custom RPC URL"
        echo "5. Exit"
        read -p "Enter the option number (1, 2, 3, 4, or 5): " rpc_option

        case $rpc_option in
            1)
                echo "Using standard Testnet RPC: Lavenderfive."
                RPC_ENDPOINT="https://testnet-nillion-rpc.lavenderfive.com"
                ;;

            2)
                echo "Using Testnet RPC: Polkachu."
                RPC_ENDPOINT="https://nillion-testnet-rpc.polkachu.com/"
                ;;

            3)
                echo "Using Testnet RPC: KJNodes."
                RPC_ENDPOINT="https://nillion-testnet.rpc.kjnodes.com/"
                ;;

            4)
                read -p "Enter the custom RPC URL: " CUSTOM_RPC
                RPC_ENDPOINT="$CUSTOM_RPC"
                echo "Using custom RPC: $RPC_ENDPOINT"
                ;;

            5)
                echo "Exiting the RPC change option."
                exit 0
                ;;

            *)
                echo "Invalid option. Exiting."
                exit 1
                ;;
        esac

        # Find and kill the running nillion/verifier container
        CONTAINER_ID=$(docker ps -q --filter ancestor=nillion/verifier:v1.0.1)
        if [ -n "$CONTAINER_ID" ]; then
            echo "Stopping and removing the running container..."
            docker kill "$CONTAINER_ID"
            docker rm "$CONTAINER_ID"
            echo "Container stopped and removed."
        else
            echo "No running container found for the image nillion/verifier:v1.0.1. Ignoring..."
        fi

        # Run the Verifier node with the selected or custom RPC
        echo "Starting the Nillion Verifier node with the selected RPC endpoint..."
        docker run -v "$(pwd)/nillion/verifier:/var/tmp" nillion/verifier:v1.0.1 verify --rpc-endpoint "$RPC_ENDPOINT"

        echo "Nillion Verifier node is now running with RPC endpoint: $RPC_ENDPOINT"
        ;;

    *)
        echo "Invalid option selected. Exiting."
        exit 1
        ;;
esac
