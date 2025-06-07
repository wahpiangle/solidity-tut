import { useState } from "react";

const AddTweet = ({ contract, account, getTweets }: any) => {
    const [newTweet, setNewTweet] = useState("");
    const [loading, setLoading] = useState(false);

    async function createTweet(tweet: string) {
        if (!contract || !account) {
            console.error(
                "Web3 or contract not initialized or account not connected."
            );
            return;
        }
        try {
            setLoading(true);
            await contract.methods.createTweet(tweet).send({ from: account });
            getTweets();
        } catch (error) {
            console.error("User rejected request:", error);
        } finally {
            setLoading(false);
        }
    }

    return (
        <form
            id="tweetForm"
            onSubmit={(e) => {
                e.preventDefault();
                createTweet(newTweet);
            }}
        >
            <textarea
                id="tweetContent"
                placeholder="What's happening?"
                value={newTweet}
                onChange={(e) => setNewTweet(e.target.value)}
            />
            <br />
            <button id="tweetSubmitBtn" disabled={loading} type="submit">
                {loading ? <div className="spinner"></div> : <>Tweet</>}
            </button>
        </form>
    );
};

export default AddTweet;
