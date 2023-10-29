// The 'zk_dao_cli' program.
program zk_dao_cli_v0_0_4.aleo {
    mapping dao_members: address => u8;
    mapping dao_admins: address => u8;
    mapping initial_airdrop_claimed: address => bool;
    transition join_dao(member_address: address) {
        return then finalize(member_address);
    }

    finalize join_dao(member_address: address) {
        Mapping::set(dao_members, member_address, 1u8);
    }

    record zk_dao_token {
        owner: address,
        amount: u64,
    }

    transition claim_airdrop(receiver: address) -> zk_dao_token {
        assert_eq(receiver, self.caller);

        return zk_dao_token {
            owner: self.caller,
            amount: 1000u64,
        } then finalize(receiver);
    }

    finalize claim_airdrop(user: address) {
        let airdrop_already_claimed: bool = Mapping::contains(initial_airdrop_claimed, user);
        let user_in_dao: bool = Mapping::contains(dao_members, user);

        // ensure user is in the dao
        assert_eq(user_in_dao, true);

        // // ensure user hasn't yet claimed the airdrop
        assert_neq(airdrop_already_claimed, true);

        Mapping::set(initial_airdrop_claimed, user, true);
    }
}
