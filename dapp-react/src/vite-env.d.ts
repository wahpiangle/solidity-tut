/// <reference types="vite/client" />
import { ExternalProvider } from "@ethersproject/providers";

declare global {
    interface Window {
        ethereum?: ExternalProvider;
    }
}

interface Tweet {
    id: number,
    author: string,
    content: string,
    timestamp: bigint,
    likeCount: number,
}

interface UserProfile {
    displayName: string,
    bio: string,
}

// struct UserProfile {
//     string displayName;
//     string bio;
// }
// struct TweetView {
//     uint256 id;
//     address author;
//     string content;
//     uint256 timestamp;
//     uint256 likeCount;
// }