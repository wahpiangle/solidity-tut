import Web3 from "web3";
import { contractAddress, profileContractAbi, profileContractAddress, sepoliaNetworkId, twitterAbi } from "../contracts";

const Connect = ({
    account,
    setContract,
    setAccount,
    setProfileContract,
    setWeb3
}: any) => {
    async function switchToSepolia() {
        try {
            // Request user to switch to Sepolia
            await window.ethereum.request({
                method: "wallet_switchEthereumChain",
                params: [{ chainId: "0xaa36a7" }] // Chain ID for Sepolia in hexadecimal
            });
        } catch (switchError: any) {
            if (switchError.code === 4902) {
                try {
                    // If Sepolia is not added to user's MetaMask, add it
                    await window.ethereum.request({
                        method: "wallet_addEthereumChain",
                        params: [
                            {
                                chainId: "0xaa36a7",
                                chainName: "Sepolia",
                                nativeCurrency: {
                                    name: "ETH",
                                    symbol: "ETH",
                                    decimals: 18
                                },
                                rpcUrls: ["https://rpc.sepolia.org"]
                            }
                        ]
                    });
                } catch (addError) {
                    console.error("Failed to add Sepolia network to MetaMask", addError);
                }
            } else {
                console.error("Failed to switch to Sepolia network", switchError);
            }
        }
    }

    async function connectWallet() {
        if (window.ethereum) {
            try {
                await window.ethereum.enable();
                const networkId = await window.ethereum.request({
                    method: "net_version"
                });

                if (networkId !== sepoliaNetworkId) {
                    await switchToSepolia();
                }

                const web3 = new Web3(window.ethereum);
                setWeb3(web3);
                const contractInstance = new web3.eth.Contract(
                    twitterAbi,
                    contractAddress
                );

                const profileContractInstance = new web3.eth.Contract(
                    profileContractAbi,
                    profileContractAddress
                );
                setProfileContract(profileContractInstance);
                const accounts = await web3.eth.getAccounts();
                if (accounts.length > 0) {
                    setContract(contractInstance);
                    setAccount(accounts[0]);
                }
            } catch (error) {
                console.error(error);
            }
        } else {
            console.error("No web3 provider detected");
        }
    }

    return (
        <>
            <div className="connect">
                {!account ? (
                    <button id="connectWalletBtn" onClick={connectWallet}>
                        Connect Wallet
                    </button>
                ) : (
                    <div id="userAddress">Connected: {account}</div>
                )}
            </div>
            <div id="connectMessage">
                {!account ? "Please connect your wallet to tweet." : ""}
            </div>
        </>
    );
};

export default Connect;
