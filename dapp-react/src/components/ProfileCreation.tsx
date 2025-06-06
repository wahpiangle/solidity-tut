import { useState } from "react";
import type { AbiItem, Contract } from "web3";

const ProfileCreation = (
    { checkProfile, profileContract, account }:
        {
            checkProfile: () => Promise<void>,
            profileContract: Contract<AbiItem[]> | null,
            account: string,
        }) => {
    const [username, setUsername] = useState("");
    const [bio, setBio] = useState("");
    const [loading, setLoading] = useState(false);

    const createProfile = async (event: any) => {
        event.preventDefault();

        try {
            setLoading(true);
            await profileContract?.methods.setProfile(account, username, bio).send({ from: account })
            checkProfile();
        } catch (error) {
            console.error(error);
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="create-profile-form">
            <h2>Create your profile</h2>
            <form onSubmit={createProfile}>
                <label>
                    Username:
                    <input
                        type="text"
                        value={username}
                        onChange={(e) => setUsername(e.target.value)}
                        required
                        className="profile-input"
                    />
                </label>
                <label>
                    Bio:
                    <textarea
                        value={bio}
                        onChange={(e) => setBio(e.target.value)}
                        className="profile-input"
                    />
                </label>
                <button type="submit" className="profile-submit">
                    {loading ? <div className="spinner"></div> : <>Create Profile</>}
                </button>
            </form>
        </div>
    );
};

export default ProfileCreation;
