program zk_dao_cli_v0_0_4.aleo;

record zk_dao_token:
    owner as address.private;
    amount as u64.private;


mapping dao_members:
	key as address.public;
	value as u8.public;


mapping dao_admins:
	key as address.public;
	value as u8.public;


mapping initial_airdrop_claimed:
	key as address.public;
	value as boolean.public;

function join_dao:
    input r0 as address.private;
    async join_dao r0 into r1;
    output r1 as zk_dao_cli_v0_0_4.aleo/join_dao.future;

finalize join_dao:
    input r0 as address.public;
    set 1u8 into dao_members[r0];


function claim_airdrop:
    input r0 as address.private;
    assert.eq r0 self.caller;
    cast self.caller 1000u64 into r1 as zk_dao_token.record;
    async claim_airdrop r0 into r2;
    output r1 as zk_dao_token.record;
    output r2 as zk_dao_cli_v0_0_4.aleo/claim_airdrop.future;

finalize claim_airdrop:
    input r0 as address.public;
    contains initial_airdrop_claimed[r0] into r1;
    contains dao_members[r0] into r2;
    assert.eq r2 true;
    assert.neq r1 true;
    set true into initial_airdrop_claimed[r0];
