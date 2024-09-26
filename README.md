# Nillion

![image](https://github.com/user-attachments/assets/33731284-da4a-4068-b6fd-31c27671c810)
  ## Nillion — a platform for decentralised data storage and processing based on the mathematically innovative Nil Message Compute (NMC) technology. This technology fundamentally changes the approach to data storage, processing and decentralisation, which will bring major changes to the landscape of the crypto-security world.
$20,600,000 investment from Distributed Global, HashKey Capital, GSR, etc. Node requirements are 2CPU/4RAM/100SSD


The Keplr EVM wallet is required to run the node. In addition to the node, the project offers the user to stack the EHT, as well as perform simple buildings (hand photos and the like).

### What's required:
- Server on Linux
- Keplr EVM wallet

Before installing noda, install yourself a [Keplr](https://www.keplr.app/) wallet. 
After that, go to https://verifier.nillion.com and connect Keplr.
Now you need to add NillionTestnet to Kepl. At https://chains.keplr.app search for Nillon and add it to your Keplr. Open the Keplr extension, in the menub on the left click on Manage Chain Visibility and select Nillon.
Next you need nillion address, which you can copy to Keplr (format: nillion1tda..trd). At https://faucet.testnet.nillion.com you need to get test tokens for the copied address. 


## Node installation

![image](https://github.com/user-attachments/assets/224b9516-1a1d-44e0-990a-23a32e693688)

You can use the script from NodeMafia to easily install, update and manage RPC. Just use 
```
curl -s https://raw.githubusercontent.com/NodeMafia/NillionNodeGuide/refs/heads/main/NillionSetup.sh | bash
```
and follow the instructions, or use the guide below.



Click to the right on Verifier. Select Setup fo Linux. After the window opens, select option 5, you will need it in the future.

Download the docker image .

```
docker pull nillion/verifier:v1.0.1
```

Creating a directory for the node.

```
mkdir -p nillion/verifier
```

Initialise the verifier.After running this command, you should see your credentials.json data. Copy your AccountID and get more test tokens to this address [here](https://faucet.testnet.nillion.com).

Then, on the Nillion website we opened at the beginning of this guide, enter your Verifier account id and Verifier public key and click Complete Verifier Connection. Wait 5 minutes for the node to synchronise.
```
docker run -v ./nillion/verifier:/var/tmp nillion/verifier:v1.0.1 initialise
```
![image](https://github.com/user-attachments/assets/d56e7f28-1ae6-4ab7-a001-833f61c81e9d)

After waiting 5 minutes, execute the final command.

```
docker run -v ./nillion/verifier:/var/tmp nillion/verifier:v1.0.1 verify --rpc-endpoint "https://testnet-nillion-rpc.lavenderfive.com"
```
## Updating the node
```
docker ps 
```
Select the Container ID of your Nillion node 
```
docker kill Container_ID
docker rm Container_ID
docker pull nillion/verifier:vACTUALVERSION*check_on_website
docker run -v ./nillion/verifier:/var/tmp nillion/verifier:vACTUALVERSION*check_on_website verify --rpc-endpoint "https://testnet-nillion-rpc.lavenderfive.com"
```
Community Nillion on [Discord](https://discord.gg/nillionnetwork).
