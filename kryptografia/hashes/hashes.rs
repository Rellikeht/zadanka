use md5;
use std::collections::HashMap;
// https://docs.rs/md5/latest/md5/

type HashType = [u8; 16];
type PassType = String;

pub fn gen_pass(i: usize, length: u32) -> PassType {
    return format!("{0:0len$}", i, len = length as usize);
}

fn reduction(pass: &HashType, password_length: u32, pos: usize) -> PassType {
    let asnum = u128::from_le_bytes(*pass);
    let digits = u128::pow(10, password_length);
    let num = (asnum + pos as u128 + 1) % digits;
    return gen_pass(num as usize, password_length);
    // return format!("{}", num);
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

pub fn lookup_in_rainbow_table(
    table: &HashMap<HashType, PassType>,
    chain_length: usize,
    pass_length: u32,
    target_hash: &HashType,
) -> Option<PassType> {
    for (_, start) in table.iter() {
        let mut cur_hash = md5::compute(start.as_bytes());
        if cur_hash == *target_hash {
            return Some(start.clone());
        }
        let mut cur_pass: String;
        for i in 1..chain_length {
            cur_pass = reduction(&cur_hash, pass_length, i - 1);
            cur_hash = md5::compute(cur_pass.as_bytes());
            if cur_hash == *target_hash {
                return Some(cur_pass);
            }
        }
    }
    return None;
}
