import './App.css'
import { useEffect, useState } from "react";
import { Contract } from "web3-eth-contract"
import type { AbiItem } from 'web3-utils';
// 2️⃣ Complete createProfile() function in ProfileCreation.js to create profile for a new user
// 3️⃣ Set the correct profileContractAddress and contractAddress in Connect.js

import Tweets from "./components/Tweets";
import AddTweet from "./components/AddTweet";
import ProfileCreation from "./components/ProfileCreation";
import Connect from './components/Connect';
import type { UserProfile, Tweet } from './vite-env';

export default function App() {
  const [account, setAccount] = useState<string>("");
  const [profileExists, setProfileExists] = useState<UserProfile | undefined>(undefined);
  const [web3, setWeb3] = useState(null);
  const [contract, setContract] = useState<Contract<AbiItem[]> | null>(null);
  const [profileContract, setProfileContract] = useState<Contract<AbiItem[]> | null>(null);
  const [tweets, setTweets] = useState<Tweet[]>([]);
  const [loading, setLoading] = useState(true);

  async function getTweets() {
    if (!web3 || !contract) {
      console.error("Web3 or contract not initialized.");
      return;
    }

    const tweets = await contract.methods.getTweets(account).call() as Tweet[];
    setTweets(
      tweets.sort((a, b) => {
        if (a.timestamp > b.timestamp) return -1;
        if (a.timestamp < b.timestamp) return 1;
        return 0;
      })
    );

    setLoading(false);
  }

  async function checkProfile() {
    if (!web3 || !profileContract || !account) {
      console.error(
        "Web3 or profileContract not initialized or account not connected."
      );
      return;
    }
    setLoading(false);

    setProfileExists(await profileContract?.methods.getProfile(account).call({ from: account }));
  }


  useEffect(() => {
    if (contract && account) {
      if (profileExists) {
        getTweets();
      } else {
        checkProfile();
      }
    }
  }, [contract, account, profileExists]);
  return (
    <div className="container">
      <h1>Twitter DAPP</h1>
      <Connect
        setWeb3={setWeb3}
        account={account}
        setAccount={setAccount}
        setContract={setContract}
        setProfileContract={setProfileContract}
      />
      {!loading && account && profileExists ? (
        <>
          <AddTweet
            contract={contract}
            account={account}
            getTweets={getTweets}
          />
          <Tweets tweets={tweets} />
        </>
      ) : (
        account &&
        !loading && (
          <ProfileCreation
            account={account}
            profileContract={profileContract}
            checkProfile={checkProfile}
          />
        )
      )}
    </div>
  );
}
