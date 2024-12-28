use md5;
use std::collections::HashMap;
// https://docs.rs/md5/latest/md5/

type HashType = [u8; 16];
type PassType = String;

fn reduction(pass: &HashType, password_length: u32, pos: usize) -> PassType {
    let asnum = u128::from_le_bytes(*pass);
    return format!("{}", (asnum + pos as u128) % u128::pow(10, password_length));
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

pub fn lookup_in_rainbow_table(
    table: &HashMap<HashType, PassType>,
    chain_length: usize,
    pass_length: u32,
    target_hash: &HashType,
) -> Option<PassType> {
    for (_, start) in table.iter() {
        let cur_hash = md5::compute(start.as_bytes());
        if cur_hash == *target_hash {
            return Some(start.clone());
        }
        let mut cur_pass: String = reduction(&cur_hash, pass_length, 0);
        for i in 1..chain_length {
            let cur_hash = md5::compute(cur_pass.as_bytes());
            if cur_hash == *target_hash {
                return Some(cur_pass);
            }
            cur_pass = reduction(&cur_hash, pass_length, i);
        }
    }
    return None;
}
