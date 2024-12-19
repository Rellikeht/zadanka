use md5;
use std::collections::HashMap;
// https://docs.rs/md5/latest/md5/

type Num = u64;
type HashType = [u8; 16];
type PassType = String;

const CHAIN_LENGTH: Num = 100;
const NUM_CHAINS: Num = 50;
const PASSWORD_LENGTH: Num = 4;
const CHARSET: [u8; 10] = {
    let mut chars = [b'0'; 10];
    let mut i = 1;
    while i < 10 {
        chars[i] += i as u8;
        i += 1;
    }
    chars
};

pub fn reduction(pass: &HashType, length: usize, pos: usize) -> PassType {
    // let asnum = u128::from_str_radix(&pass, 16).unwrap();
    let asstr = String::from_utf8_lossy(pass);
    let asnum = u128::from_str_radix(&asstr, 16).unwrap();
    return format!("{}", (asnum + pos as u128) % u128::pow(10, length as u32));
}

pub fn gen_pass(i: usize, length: usize) -> PassType {
    return format!("{0:0len$}", i, len = length);
}

pub fn generate_rainbow_table(
    chains: usize,
    chain_length: usize,
    pass_length: usize,
) -> HashMap<HashType, PassType> {
    let mut map = HashMap::with_capacity(chains);

    for i in 0..chains {
        let start_pass = gen_pass(i, pass_length);
        let mut cur_pass = start_pass.clone();
        let mut cur_hash: HashType = HashType::default();

        for j in 0..chain_length {
            cur_hash = md5::compute(cur_pass.as_bytes());
            cur_pass = reduction(&cur_hash, pass_length, j);
        }

        map.insert(cur_hash, start_pass);
    }
    return map;
}

pub fn main() {
    for i in 0..100 {
        println!("{}", gen_pass(i, 4));
    }
}
