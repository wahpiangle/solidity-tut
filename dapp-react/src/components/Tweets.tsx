import type { Tweet } from "../vite-env";

const Tweets = ({ tweets }: any) => {
    return (
        <div id="tweetsContainer">
            {tweets.map((tweet: Tweet, index: number) => (
                <div key={index} className="tweet">
                    <img
                        className="user-icon"
                        src={`https://api.dicebear.com/9.x/pixel-art/svg`}
                        alt="User Icon"
                    />
                    <div className="tweet-inner">
                        <div className="author">{tweet.author}</div>
                        <div className="content">{tweet.content}</div>
                    </div>
                </div>
            ))}
        </div>
    );
};

export default Tweets;
