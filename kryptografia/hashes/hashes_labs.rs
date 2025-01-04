use md5;
use std::collections::HashMap;
// https://docs.rs/md5/latest/md5/

type HashType = [u8; 16];
type PassType = String;

fn reduction(pass: &HashType, password_length: u32, pos: usize) -> PassType {
    let asnum = u128::from_le_bytes(*pass);
    let digits = u128::pow(10, password_length);
    return format!("{}", (asnum + pos as u128 + 1) % digits);
}

pub fn gen_pass(i: usize, length: u32) -> PassType {
    return format!("{0:0len$}", i, len = length as usize);
}

pub fn generate_rainbow_table(
    chains: usize,
    chain_length: usize,
    pass_length: u32,
) -> HashMap<HashType, PassType> {
    let mut map = HashMap::with_capacity(chains);
    for i in 0..chains {
        let start_pass = gen_pass(i, pass_length);
        let mut cur_hash: HashType = md5::compute(start_pass.as_bytes());
        for j in 1..chain_length {
            let cur_pass = reduction(&cur_hash, pass_length, j);
            cur_hash = md5::compute(cur_pass.as_bytes());
        }
        map.insert(cur_hash, start_pass);
    }
    return map;
}

fn last_in_chain(
    start: &PassType,
    chain_length: usize,
    pass_length: u32, //
) -> PassType {
    let mut cur_pass = start.clone();
    for i in 0..chain_length - 1 {
        let cur_hash = md5::compute(cur_pass.as_bytes());
        cur_pass = reduction(&cur_hash, pass_length, i);
    }
    return cur_pass;
}

pub fn lookup_in_rainbow_table(
    table: &HashMap<HashType, PassType>,
    chain_length: usize,
    pass_length: u32,
    target_hash: &HashType,
) -> Option<PassType> {
    let mut cur_hash = *target_hash;
    for i in 0..chain_length {
        match table.get(&cur_hash) {
            Some(new_start) => {
                let found = last_in_chain(
                    new_start,
                    chain_length - i,
                    pass_length, //
                );
                println!("{} {} {}", i, new_start, found);
                println!("{:?}", cur_hash);
                println!("{:?}", md5::compute(found.as_bytes()));
                return Some(found);
            }

            None => {
                let cur_pass = reduction(&cur_hash, pass_length, i);
                cur_hash = md5::compute(cur_pass.as_bytes());
            }
        }
    }
    return None;
}
