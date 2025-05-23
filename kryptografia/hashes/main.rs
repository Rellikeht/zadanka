use std::{env, usize};

use hashes::*;

const CHAIN_LENGTH: usize = 100;
const NUM_CHAINS: usize = 50;
const PASSWORD_LENGTH: u32 = 4;

// copied from labs
const CHARSET: [u8; 10] = {
    let mut chars = [b'0'; 10];
    let mut i = 1;
    while i < 10 {
        chars[i] += i as u8;
        i += 1;
    }
    chars
};

pub fn main() {
    let args: Vec<String> = env::args().collect();
    let password_length: u32;
    let num_chains: usize;
    if args.len() > 1 {
        password_length = args[1].parse().unwrap();
        num_chains = NUM_CHAINS * usize::pow(10, password_length) / usize::pow(10, PASSWORD_LENGTH);
    } else {
        password_length = PASSWORD_LENGTH;
        num_chains = NUM_CHAINS;
    }

    let table = generate_rainbow_table(
        num_chains,
        CHAIN_LENGTH,
        password_length, //
    );
    // println!("{:?}", table.keys().collect::<Vec<_>>());

    let mut cracked = 0;
    for i in 0..usize::pow(10, password_length) {
        let pass = gen_pass(i, password_length);
        let hash = md5::compute(pass.as_bytes());
        let lookup = lookup_in_rainbow_table(&table, CHAIN_LENGTH, password_length, &hash);
        match lookup {
            Some(p) => {
                cracked += 1;
                // println!("{} {}", pass, p);
            }
            None => {}
        }
    }
    println!("{}", cracked);
}
